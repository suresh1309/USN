
//The following section creates a VM and attaches the virtual NIC to it.
resource "azurerm_virtual_machine" "sqlvm" {
  name                  = var.vm_sql_name
  location              = var.location
  resource_group_name   = var.resource_group_name #data.azurerm_resource_group.rg.name
  network_interface_ids = [var.sql_vm_nic_ip]
  vm_size               = var.vm_size

  //https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage
  //Search the VM images in the Azure Marketplace using Azure CLI tool

  //az vm image list --location westeurope  --publisher MicrosoftSQLServer  --all --output table

  storage_image_reference {
    offer     = var.i_offer
    publisher = var.i_publisher
    sku       = var.i_sku
    version   = var.i_version
  }

  //boot diagnosetic: here you can provide  the url of the blob for the boot logs storage
  # boot_diagnostics {
  #     enabled     = true
  #     storage_uri = "${var.boot_url}"
  #     }

  //Windows OS disk by default it is of 128 GB
  storage_os_disk {
    name              = var.os_disk
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  // Adding additional disk for persistent storage (need to be mounted to the VM using diskmanagement )
  storage_data_disk {
    name              = var.add_disk_name
    managed_disk_type = "StandardSSD_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = var.add_disk_size
  }

  //Assign the admin uid/pwd and also comupter name
  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  //Here defined autoupdate config and also vm agent config
  os_profile_windows_config {
    //enable_automatic_upgrades = true  
    provision_vm_agent = true
  }
  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "sqlvm_antimalware" {
  name                       = "IaaSAntimalware"
  virtual_machine_id         = azurerm_virtual_machine.sqlvm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "AntimalwareEnabled": true,
        "RealtimeProtectionEnabled": "true",
        "ScheduledScanSettings": {
            "isEnabled": "true",
            "day": "7",
            "time": "120",
            "scanType": "Quick"
            },
        "Exclusions": {
            "Extensions": "",
            "Paths": "",
            "Processes": ""
            }
    }
SETTINGS

}

resource "azurerm_mssql_virtual_machine" "sql" {
  virtual_machine_id               = azurerm_virtual_machine.sqlvm.id
  sql_license_type                 = "PAYG"
  r_services_enabled               = true
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = "Siesm@rt&579$"
  sql_connectivity_update_username = "sysadmin"

  auto_patching {
    day_of_week                            = "Sunday"
    maintenance_window_duration_in_minutes = 60
    maintenance_window_starting_hour       = 2
  }
}

data "azurerm_managed_disk" "sqldisk1" {
  name                = var.sqldisk1_name
  resource_group_name = var.sql_rg
}
data "azurerm_managed_disk" "sqldisk2" {
  name                = var.sqldisk2_name
  resource_group_name = var.sql_rg
}
data "azurerm_managed_disk" "sqldisk3" {
  name                = var.sqldisk3_name
  resource_group_name = var.sql_rg
}
resource "azurerm_virtual_machine_data_disk_attachment" "disk1" {
  managed_disk_id    = data.azurerm_managed_disk.sqldisk1.id
  virtual_machine_id = azurerm_virtual_machine.sqlvm.id
  lun                = "1"
  caching            = "ReadWrite"
}
resource "azurerm_virtual_machine_data_disk_attachment" "disk2" {
  managed_disk_id    = data.azurerm_managed_disk.sqldisk2.id
  virtual_machine_id = azurerm_virtual_machine.sqlvm.id
  lun                = "2"
  caching            = "ReadWrite"
}
resource "azurerm_virtual_machine_data_disk_attachment" "disk3" {
  managed_disk_id    = data.azurerm_managed_disk.sqldisk3.id
  virtual_machine_id = azurerm_virtual_machine.sqlvm.id
  lun                = "3"
  caching            = "ReadWrite"
}

