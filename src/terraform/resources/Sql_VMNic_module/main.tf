

resource "azurerm_network_interface" "sqlvmnic" {
  name                = var.vm_vmnic_SQL
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  ip_configuration {
    name                          = "sqlserverNicConfiguration"
    subnet_id                     = var.subnet_data_id
    private_ip_address_allocation = var.private_ip_address_allocation

  }
}
