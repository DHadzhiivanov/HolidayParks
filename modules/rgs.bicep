targetScope = 'subscription'

var locationName = 'germanywestcentral'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'HolidayParks'
  location: locationName
}

module vnetModule 'vnet.bicep' = {
  name: 'deployVnet'
  scope: resourceGroup(rg.name)
  params: {
    location: locationName
    vnetName: 'vnet-holidayparks'
  }
}
