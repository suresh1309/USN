output "azure_vm_id" {
  description = "The ID of the virtual machine"
  value       = azurerm_virtual_machine.sqlvm.id
}
