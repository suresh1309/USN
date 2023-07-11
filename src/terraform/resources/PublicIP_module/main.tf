data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

locals {
  namelist       = split("-", var.resource_group_name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}-pip-${var.zone}-${var.environment}" : ""
}

resource "azurerm_public_ip" "main" {
  name                = var.name == "" ? local.defaultname : var.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  allocation_method   = var.allocation_method
  sku                 = var.sku
  availability_zone   = var.availability_zone
  tags                = var.tags
}
