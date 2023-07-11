data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

locals {
  namelist       = split("-", data.azurerm_resource_group.resource_group.name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}-law-${var.zone}-${var.environment}" : ""
}

resource "azurerm_private_endpoint" "endpoint" {
  name                = var.private_endpoint_name == "" ? local.defaultname : var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_connection_name
    private_connection_resource_id = var.private_link_enabled_resource_id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }
}