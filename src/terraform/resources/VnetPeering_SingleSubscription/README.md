---
layout: page
permalink: /Azure/Terraform/vnetpeering_singless/
icon: azure.png
description: Azure VNet Peering by the AKS Sogeti community.
status: Ready for Production
type: S04 Connectivity
automation: TerraformModule
onlineTemplateReference: 
onlineServiceDescription: 
packageId: unknown
buildName: unknown
name: Azure VNet Peering with Terraform
title: Azure VNet Peering with Terraform
tags:
- AKS Landing zone by Sogeti community
---

{%- include template_terraform.html -%}

# Module usage
```javascript
module "vnetpeering" {
    source               = "./module-path"
    vnet_names           = ["Transit-VNET", "Bastion-VNET"]
    resource_group_names = ["TransitRG1", "BastionRG1"]
}
```