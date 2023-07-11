---
layout: page
permalink: /Azure/Terraform/Modules/Firewall/
title: Azure Firewall Terraform module
icon: azure.png
description: Azure Firewall Terraform module by Sogeti community.
status: Ready for Production
type: S05 Security
automation: TerraformModule
onlineTemplateReference: https://docs.microsoft.com/en-us/azure/firewall/overview
onlineServiceDescription: https://docs.microsoft.com/en-us/azure/firewall/overview
packageId: unknown
buildName: unknown
name: Azure Firewall
title: Azure Firewall Terraform module
tags:
- Azure Firewall
- AKS Landing zone by Sogeti community
---

{%- include template_terraform.html -%}

## How to use

```javascript

module "azure_firewall" {
  source                = "../modules/firewall_module"
  firewall_name         = lower(join("-", [var.customer, "fw", var.applicationname_short, var.region, var.environment_short]))
  resource_group_name   = module.azurerm_rg_transit.resource_group_name
  virtual_network_name  = module.azurerm_vnet_transit.virtual_network_name
  subnet_firewall_id    = module.azurerm_snet_firewall.subnet_id
  firewall_public_ip_id = module.firewall_public_ip.id
  firewall_web_rules    = var.firewall_web_rules
  tags                  = local.tags
  depends_on            = [module.azurerm_vnet_transit]
}

```