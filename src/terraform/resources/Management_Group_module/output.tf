output "management_group_id" {
  value       = azurerm_management_group.main.*.id
  description = "The id of the management group."
}
