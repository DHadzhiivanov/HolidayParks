// server.js
//
// Minimal API for the Fonteyn booking-app demo.
// What this file does, step by step:
//
// 1. Starts a small web server (Express) that listens for requests.
// 2. Exposes one endpoint: POST /booking
//    - The HTML form on the booking-app sends its data here.
// 3. Connects to the Azure SQL Database using the mssql library.
// 4. Inserts the booking data (park, dates, guests, name, email) into the
//    "bookings" table.
// 5. Sends a success or error response back to the browser, which the
//    HTML page shows to the user.
//
// This is a temporary stopgap built by Mohammed Abdulhakk while Bouziani
// is sick, so the team has a working demo for the delivery. It is not
// part of Mohammed Abdulhakk's PRP scope.

const express = require("express");
const cors = require("cors");
const sql = require("mssql");

const app = express();
app.use(cors());
app.use(express.json());

// Database connection settings come from environment variables, so the
// password is never hardcoded in this file. We pass these in later as a
// Kubernetes Secret.
const dbConfig = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  options: {
    encrypt: true,
    trustServerCertificate: false,
  },
};

let poolPromise = sql.connect(dbConfig)
  .then((pool) => {
    console.log("Connected to Azure SQL Database");
    return pool;
  })
  .catch((err) => {
    console.error("Database connection failed:", err.message);
    throw err;
  });

app.get("/health", (req, res) => {
  res.json({ status: "API is running" });
});

app.post("/booking", async (req, res) => {
  try {
    const { park, arrival, departure, guests, name, email } = req.body;

    if (!park || !arrival || !departure || !guests || !name || !email) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const pool = await poolPromise;

    await pool.request()
      .input("park", sql.NVarChar, park)
      .input("arrival", sql.Date, arrival)
      .input("departure", sql.Date, departure)
      .input("guests", sql.NVarChar, guests)
      .input("name", sql.NVarChar, name)
      .input("email", sql.NVarChar, email)
      .query(`
        INSERT INTO bookings (park, arrival_date, departure_date, guests, full_name, email, created_at)
        VALUES (@park, @arrival, @departure, @guests, @name, @email, GETDATE())
      `);

    res.status(201).json({ message: "Booking saved successfully" });
  } catch (err) {
    console.error("Error saving booking:", err.message);
    res.status(500).json({ error: "Could not save booking" });
  }
});

app.get("/bookings", async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query(
      "SELECT TOP 50 * FROM bookings ORDER BY created_at DESC"
    );
    res.json(result.recordset);
  } catch (err) {
    console.error("Error fetching bookings:", err.message);
    res.status(500).json({ error: "Could not fetch bookings" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Booking API listening on port ${PORT}`);
});