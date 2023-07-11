output "route_table_name" {
  value = azurerm_route_table.main.name
}

output "route_table_id" {
  value = azurerm_route_table.main.id
}

output "associated_subnets" {
  value       = azurerm_route_table.main.subnets
  description = "The collection of Subnets associated with this route table."
}