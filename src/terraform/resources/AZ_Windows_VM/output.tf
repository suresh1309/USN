output "azure_vm_nic_ip_integration" {
  description = "The public IP of the virtual machine"
  value       = azurerm_network_interface.main.id
}
output "monitoring_vm_id" {
  description = "The ID of the virtual machine"
  value       = element(coalescelist(azurerm_virtual_machine.main.*.id, [""]), 0)
}