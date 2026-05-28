param location string

resource hubVnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'vnet-fonteyn-hub'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.0.0/27'
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.1.0/26'
        }
      }
    ]
  }
}

resource spokeWorkloads 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'vnet-fonteyn-booking'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-app'
        properties: {
          addressPrefix: '10.1.0.0/24'
        }
      }
      {
        name: 'snet-database'
        properties: {
          addressPrefix: '10.1.1.0/24'
        }
      }
    ]
  }
}

resource spokeIoT 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'vnet-fonteyn-iot'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-app'
        properties: {
          addressPrefix: '10.2.0.0/24'
        }
      }
      {
        name: 'snet-storage'
        properties: {
          addressPrefix: '10.2.1.0/24'
        }
      }
      {
        name: 'snet-iot'
        properties: {
          addressPrefix: '10.2.2.0/24'
        }
      }
    ]
  }
}

resource spokeManagement 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'vnet-fonteyn-management'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.3.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-monitoring'
        properties: {
          addressPrefix: '10.3.0.0/24'
        }
      }
      {
        name: 'snet-backups'
        properties: {
          addressPrefix: '10.3.1.0/24'
        }
      }
    ]
  }
}

resource spokeDev 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'vnet-development'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.4.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-test'
        properties: {
          addressPrefix: '10.4.0.0/24'
        }
      }
    ]
  }
}
