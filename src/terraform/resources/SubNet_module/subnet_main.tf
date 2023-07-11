data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

locals {
  namelist       = split("-", data.azurerm_resource_group.main.name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}subnet${local.namelist[1]}${local.namelist[2]}${local.namelist[3]}" : ""
}

resource "azurerm_subnet" "main" {
  name                                           = var.name == "" ? local.defaultname : var.name
  resource_group_name                            = data.azurerm_resource_group.main.name
  address_prefixes                               = var.subnet_addressSpaces
  virtual_network_name                           = var.virtual_network_name
  service_endpoints                              = var.service_endpoints
  enforce_private_link_endpoint_network_policies = true

}
