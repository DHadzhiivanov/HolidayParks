param location string

resource nsgWorkloads 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-snet-app'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowInboundInternet'
        properties: {
          description: 'allow internet on port 443'
          protocol: 'Tcp'
          sourcePortRange: '443'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowDataFromAppInbound'
        properties: {
          description: 'allow app to talk to sql database'
          protocol: 'Tcp'
          sourcePortRange: '1433'
          destinationPortRange: '1433'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource nsgIoT 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg-snet-'
  location: location
  properties: {
    securityRules: [
      {
        name: 'nsg-snet-iot'
        properties: {
          description: 'allow inbound sensor data from vpn gateway'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}
