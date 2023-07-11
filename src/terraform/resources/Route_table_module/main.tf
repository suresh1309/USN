data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_route_table" "main" {
  name                          = var.name
  location                      = data.azurerm_resource_group.main.location
  resource_group_name           = data.azurerm_resource_group.main.name
  disable_bgp_route_propagation = false

  route {
    name           = "firewallroutes"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "internet"
  }
  tags = var.tags
}