data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}
locals {
  namelist       = split("-", data.azurerm_resource_group.main.name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}-vm-${var.applicationname}-${var.environment}" : ""
}

resource "azurerm_network_interface" "main" {
  name                = var.nic_name == "" ? local.defaultname : var.nic_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = var.ip_config_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    #public_ip_address_id         = var.public_ip_address_id
  }
}

resource "azurerm_virtual_machine" "main" {
  count                 = var.create_lmsvm ? 1 : 0
  name                  = var.vm_name == "" ? local.defaultname : var.vm_name
  location              = data.azurerm_resource_group.main.location
  resource_group_name   = data.azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size
  storage_image_reference {
    offer     = var.i_offer
    publisher = var.i_publisher
    sku       = var.i_sku
    version   = var.i_version
  }
  storage_os_disk {
    name              = var.os_disk_name
    caching           = var.caching
    create_option     = var.create_option
    managed_disk_type = var.managed_disk_type
  }
  # storage_data_disk {
  #   name              = var.add_disk_name
  #   managed_disk_type = var.managed_disk_type
  #   create_option     = var.cr_option
  #   lun               = var.lun
  #   disk_size_gb      = var.add_disk_size
  # }
  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_windows_config {
    provision_vm_agent = var.provision_vm_agent
  }
  tags = var.tags
}