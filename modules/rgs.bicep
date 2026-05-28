targetScope = 'subscription'
param location string

// core network connectivity
resource rgNetwork 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-fonteyn-network'
  location: location
}
// logs, monitoring, any automation
resource rgManagement 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-fonteyn-management'
  location: location
}
// entra id, private DNS zones if any
resource rgIdentity 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-fonteyn-identity'
  location: location
}
// keyvaults, defender for cloud
resource rgSecurity 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-fonteyn-security'
  location: location
}
// production
resource rgWorkloadsProd 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-fonteyn-workloads-prod'
  location: location
}
// sandbox
resource rgWorkloadsDev 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-fonteyn-workloads-dev'
  location: location
}
