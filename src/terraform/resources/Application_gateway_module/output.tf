output "id" {
  description = "Id of the application gateway."
  value       = azurerm_application_gateway.main.id
}

/* output "waffirewallpolicy_id" {
  description = "Id of the application gateway."
  value       = azurerm_web_application_firewall_policy.waf_policy.id
} 

output "user_assigned_identity" {
  description = "Resource id and client id of the user assigned identity."
  value = {
    id           = azurerm_user_assigned_identity.main.id
    client_id    = azurerm_user_assigned_identity.main.client_id
    principal_id = azurerm_user_assigned_identity.main.principal_id
    tenant_id    = azurerm_user_assigned_identity.main.tenant_id
  }
}

*/