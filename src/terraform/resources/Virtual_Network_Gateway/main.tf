data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}
locals {
  namelist       = split("-", data.azurerm_resource_group.main.name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}-vngw-${var.applicationname}-${var.environment}" : ""
}
# creating the resource for azure virtual network gateway and valid items
resource "azurerm_virtual_network_gateway" "main" {
  name                = var.name == "" ? local.defaultname : var.name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  tags                = var.tags
  type                = var.type
  vpn_type            = var.vpn_type
  enable_bgp          = var.enable_bgp
  active_active       = var.active_active
  sku                 = var.sku
  ip_configuration {
    private_ip_address_allocation = var.private_ip_allocation
    public_ip_address_id          = var.azurerm_public_ip
    subnet_id                     = var.azurerm_subnet
  }
}