data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

locals {
  namelist       = split("-", data.azurerm_resource_group.main.name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}-vnet-${var.zone}-${var.environment}" : ""
}

resource "azurerm_virtual_network" "main" {
  name                = var.name == "" ? local.defaultname : var.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = var.addressSpace
  dns_servers         = var.vnet_dns_servers
  tags                = var.tags
}

