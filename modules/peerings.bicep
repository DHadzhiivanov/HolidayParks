targetScope = 'resourceGroup'
param location string

resource hubVnet 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: 'vnet-fonteyn-hub' 
}

resource spokeWorkloads 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: 'vnet-fonteyn-booking' 
}

resource hubtoBookingPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2019-11-01' = {
  parent: hubVnet
  name: 'hub-to-booking'
  properties: {
    remoteVirtualNetwork: {
      id: spokeWorkloads.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
  }
}

resource bookingToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2019-11-01' = {
  parent: spokeWorkloads
  name: 'booking-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
  }
}
