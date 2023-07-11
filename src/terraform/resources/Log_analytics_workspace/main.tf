data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

locals {
  namelist       = split("-", data.azurerm_resource_group.resource_group.name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}-law-${var.zone}-${var.environment}" : ""
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.law_name == "" ? local.defaultname : var.law_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  retention_in_days   = var.retention_in_days
  sku                 = var.log_analytics_sku
  tags                = var.tags
}
