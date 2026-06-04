param location string

// NSG 1
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
    ]
  }
}

// NSG 2
resource nsgData 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-booking-db'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-from-app-subnet'
        properties: {
          description: 'Allow app subnet to reach SQL on 1433'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: '10.1.0.0/24'
          destinationAddressPrefix: '10.1.1.0/24'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          description: 'Block everything else while respecting Azure infrastructure requirements'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '10.1.1.0/24'
          access: 'Deny'
          priority: 200
          direction: 'Inbound'
        }
      }
      {
        name: 'Deny-Internet'
        properties: {
          description: 'Block direct Internet access from DB subnet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.1.1.0/24'
          destinationAddressPrefix: 'Internet'
          access: 'Deny'
          priority: 300
          direction: 'Outbound'
        }
      }
    ]
  }
}

// NSG 3
resource nsgIoT 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-iot-devices'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Deny-All-Inbound'
        properties: {
          description: 'Block all inbound traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.2.2.0/24'
          destinationAddressPrefix: 'AzureIoTHub'
          access: 'Deny'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-To-IotHub'
        properties: {
          description: 'Allow traffic to IOT Hub'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: ['443', '5671', '8883']
          sourceAddressPrefix: '10.2.2.0/24'
          destinationAddressPrefix: 'AzureIoTHub'
          access: 'Allow'
          priority: 200
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-To-App'
        properties: {
          description: 'Allow traffic to Application'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.2.2.0/24'
          destinationAddressPrefix: 'AzureIoTHub'
          access: 'Allow'
          priority: 210
          direction: 'Outbound'
        }
      }
    ]
  }
}

// NSG 4
resource nsgIoTData 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-iot-storage'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Inbound'
        properties: {
          description: 'Allow storage protocols from IoT devices'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: ['445', '2049']
          sourceAddressPrefix: '10.2.0.0/24'
          destinationAddressPrefix: '10.2.1.0/24'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

// NSG 5 - NSG TO LOOK AT LATER AFTER PRP
resource nsgManagementMonitoring 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-management-monitoring'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Logs-Inbound'
        properties: {
          description: 'Allow storage protocols from IoT devices'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: ['514']  // Syslog for now, might need to changer later after PRP!!!
          sourceAddressPrefix: '10.0.0.0/8'
          destinationAddressPrefix: '10.3.0.0/24'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-All-Internal'
        properties: {
          description: 'Allows monitoring tools to query and reach the resources'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 200
          direction: 'Outbound'
        }
      }
    ]
  }
}

// NSG 6
resource nsgManagementBacking 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-management-backups'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-To-Recovery-Vault'
        properties: {
          description: 'Allows communication to Azure Recovery Vault endpoints'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '10.3.1.0/24'
          destinationAddressPrefix: 'AzureBackup'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-To-AzureStorage'
        properties: {
          description: 'Required storage pipeline dependency for data transfer'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '10.3.1.0/24'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow-To-Identity'
        properties: {
          description: 'Required dependency for backup token validation'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '10.3.1.0/24'
          destinationAddressPrefix: 'AzureActiveDirectory'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
        }
      }
    ]
  }
}

// NSG 7
resource nsgDevelopment 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-development-test'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Hub-VPN'
        properties: {
          description: 'Allow inbound traffic from Hub VPN'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.0.0.0/27'
          destinationAddressPrefix: '10.4.0.0/24'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Deny-To-Prod'
        properties: {
          description: 'Restrict dev access to production resources'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.4.0.0/24'
          destinationAddressPrefixes: ['10.1.0.0/16','10.2.0.0/16']
          access: 'Deny'
          priority: 200
          direction: 'Outbound'
        }
      }
    ]
  }
}
