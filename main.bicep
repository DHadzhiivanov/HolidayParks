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