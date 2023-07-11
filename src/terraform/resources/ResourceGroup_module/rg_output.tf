output "id" {
  value       = azurerm_resource_group.main.id
  description = "The name the created resource group got."
}

output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "The name the created resource group got."
}
