
data "azurerm_virtual_network" "vnet0" {
  name                = var.vnet_names[0]
  resource_group_name = var.resource_group_names[0]
}

data "azurerm_virtual_network" "vnet1" {
  name                = var.vnet_names[1]
  resource_group_name = var.resource_group_names[1]
}

resource "azurerm_virtual_network_peering" "vnet_peer_0" {
  name                         = "${var.vnet_names[0]}-to-${var.vnet_names[1]}"
  resource_group_name          = var.resource_group_names[0]
  virtual_network_name         = var.vnet_names[0]
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "vnet_peer_1" {
  name                         = "${var.vnet_names[1]}-to-${var.vnet_names[0]}"
  resource_group_name          = var.resource_group_names[1]
  virtual_network_name         = var.vnet_names[1]
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet0.id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  use_remote_gateways          = var.use_remote_gateways
}