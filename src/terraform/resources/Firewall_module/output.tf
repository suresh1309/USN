output "firewall_id" {
  value = azurerm_firewall.azure_firewall.id
}

output "firewall_name" {
  value = azurerm_firewall.azure_firewall.name
}

output "firewall_private_ip" {
  description = "The private ip of firewall."
  value       = azurerm_firewall.azure_firewall.ip_configuration.0.private_ip_address
}
