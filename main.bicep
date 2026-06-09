targetScope = 'subscription'
var location = 'germanywestcentral'

module rgs 'modules/rgs.bicep' = {
  name: 'deployRGS'
  params: {
    location: location
  }
}

module nsgs 'modules/nsgs.bicep' = {
  name: 'deployNSGs'
  scope: resourceGroup('rg-fonteyn-network')
  dependsOn: [rgs]
  params: {
    location: location
  }
}

module vnets 'modules/vnet.bicep' = {
  name: 'deployVNETs'
  scope: resourceGroup('rg-fonteyn-network')
  dependsOn: [rgs, nsgs]
  params: {
    location: location
  }
}

module peerings 'modules/peerings.bicep' = {
  name: 'deployPeerings'
  scope: resourceGroup('rg-fonteyn-network')
  dependsOn: [vnets]
}

module acr 'modules/acr.bicep' = {
  name: 'deployACR'
  scope: resourceGroup('rg-fonteyn-workloads-dev')
  dependsOn: [rgs]
  params: {
    location: location
    acrName: 'acrfonteyn'
  }
}

module aks 'modules/aks.bicep' = {
  name: 'deployAKS'
  scope: resourceGroup('rg-fonteyn-workloads-dev')
  dependsOn: [rgs, acr]
  params: {
    location: location
    aksName: 'aks-fonteyn-dev'
    acrName: 'acrfonteyn'
    subnetId: '/subscriptions/49280b9e-2fde-41ae-9a7e-049ae0198daa/resourceGroups/rg-fonteyn-network/providers/Microsoft.Network/virtualNetworks/vnet-fonteyn-booking/subnets/snet-app'
  }
}