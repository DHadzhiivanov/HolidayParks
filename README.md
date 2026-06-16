# IaC Bicep Landing Zone

This repository contains a subscription-scope Azure Bicep deployment for Fonteyn Holidayparks landing-zone environment. The current template creates the core resource groups, virtual networks, network security groups, and virtual network peerings.

## Overview

The root [main.bicep](main.bicep) file is the entry point. It deploys the modules under [modules/](modules) at subscription scope and targets the `germanywestcentral` region.

The deployment is organized around a hub-and-spoke style network layout with separate resource groups for networking, management, identity, security, and workloads.

## Repository Layout

- [main.bicep](main.bicep): top-level subscription deployment that wires the modules together.
- [modules/rgs.bicep](modules/rgs.bicep): creates the resource groups used by the environment.
- [modules/nsgs.bicep](modules/nsgs.bicep): defines network security groups and baseline security rules.
- [modules/vnet.bicep](modules/vnet.bicep): creates the hub and spoke virtual networks and subnets.
- [modules/peerings.bicep](modules/peerings.bicep): configures virtual network peering between hub and spoke networks.
- [modules/services.bicep](modules/services.bicep): placeholder for future service deployments.
- [.github/workflows/azure-deploy-holidayparks.yml](.github/workflows/azure-deploy-holidayparks.yml): GitHub Actions workflow that deploys the Bicep template to Azure.

## What the Template Creates

The current Bicep files define:

- Resource groups for network, management, identity, security, production workloads, and development workloads.
- A hub virtual network with gateway and firewall subnets.
- Spoke virtual networks for booking/workloads, IoT, management, and development.
- NSGs for application, data, and IoT subnets.
- An application subnet that is associated with the application NSG.
- Virtual network peering between the hub network and booking spoke network.

## Prerequisites

Before deploying, make sure you have:

- An Azure subscription with permissions to create resource groups and network resources.
- Azure CLI installed and signed in.
- Bicep support available in Azure CLI.
- A region that supports the resources you are deploying.
- If you use GitHub Actions, an `AZURE_CREDENTIALS` secret configured in the repository.

## Deploying Manually

This project is deployed at subscription scope. A typical validation and deployment flow is:

```bash
az deployment sub what-if \
  --location germanywestcentral \
  --template-file main.bicep

az deployment sub create \
  --name fonteyn-landing-zone \
  --location germanywestcentral \
  --template-file main.bicep
```

## Deploying with GitHub Actions

The workflow in [azure-deploy-holidayparks.yml](.github/workflows/azure-deploy-holidayparks.yml) runs on pushes and pull requests to `main`, and can also be started manually.

It performs three steps:

1. Checks out the repository.
2. Logs into Azure using `secrets.AZURE_CREDENTIALS`.
3. Runs `az deployment sub create` against [main.bicep](main.bicep).

## Notes

- [modules/services.bicep](modules/services.bicep) is a placeholder for future service deployments.
- The `main.bicep` module ordering depends on the resource group module running before the network modules.
- Virtual network peering is configured between the hub network and the booking spoke network with virtual network access enabled and forwarded traffic disabled.
