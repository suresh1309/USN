data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_route_table" "main" {
  name                          = var.name
  location                      = data.azurerm_resource_group.main.location
  resource_group_name           = data.azurerm_resource_group.main.name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  tags = var.tags
}