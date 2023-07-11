output "sql_vm_nic_ip" {
  description = "The public IP of the virtual machine"
  value       = azurerm_network_interface.sqlvmnic.id
}


