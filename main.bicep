targetScope = 'subscription'
var location = 'germanywestcentral'

module rgs 'modules/rgs.bicep' = {
  name: 'deployRGS'
}

module vnets 'modules/vnet.bicep' = {
  name: 'deployVNETs'
  scope: resourceGroup('rg-fonteyn-network')
  dependsOn: [rgs]
  params: {
    location: location
  }
}

module nsgs 'modules/nsgs.bicep' = {
  name: 'deployNSGs'
  scope: resourceGroup('rg-fonteyn-network')
  dependsOn: [vnets]
}

module peerings 'modules/peerings.bicep' = {
  name: 'deployPeerings'
  scope: resourceGroup('rg-fonteyn-network')
  dependsOn: [vnets]
}
