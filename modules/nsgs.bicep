param location string

resource nsgApp 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-booking-app'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP-HTTPS-Inbound'
        properties: {
          description: 'Allow internet traffic on port 80 and 443'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: ['80', '443']
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '10.1.0.0/24'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-SQL-To-Data-SUbnet'
        properties: {
          description: 'Allow app subnet to reach SQL on 1433'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: '10.1.0.0/24'
          destinationAddressPrefix: '10.1.1.0/24'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource nsgData 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-snet-data'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowSQLFromApp'
        properties: {
          description: 'Allow app subnet to reach SQL on 1433'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: '10.1.0.0/24'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          description: 'Block everything else'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 200
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource nsgIoT 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-snet-iot'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowVPNInbound'
        properties: {
          description: 'Allow sensor data from parks over VPN'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.0.0.0/27'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          description: 'Block everything else'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 200
          direction: 'Inbound'
        }
      }
    ]
  }
}
