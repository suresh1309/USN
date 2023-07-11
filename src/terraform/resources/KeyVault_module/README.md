---
layout: page
permalink: /Azure/Terraform/Modules/KeyVault/
title: Azure KeyVault Terraform module
icon: Azure KeyVault_COLOR.png
description: Azure KeyVault Terraform module by the AKS Sogeti community.
status: Ready for Production
type: S05 Security
automation: TerraformModule
onlineTemplateReference: https://www.terraform.io/docs/providers/azurerm/r/key_vault.html
onlineServiceDescription: https://docs.microsoft.com/en-us/azure/key-vault/
packageId: unknown
buildName: unknown
name: KeyVault
title: Azure KeyVault Terraform module
tags:
- Azure Kubernetes Service community
- AKS Landing zone by Sogeti community
---

{%- include template_terraform.html -%}


https://github.com/innovationnorway/terraform-azurerm-key-vault <-- intersting

https://github.com/paulbouwer/terraform-azure-quickstarts-samples/tree/master/101-key-vault-create
https://www.terraform.io/docs/providers/azurerm/r/key_vault_key.html

to get a secret from KV
data "azurerm_key_vault_secret" "mySecret" {
name = "labuser"
vault_uri = "https://yourKeyVault.vault.azure.net/"
}