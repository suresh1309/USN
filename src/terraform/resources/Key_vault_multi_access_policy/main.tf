# ---- create azure key vault for access policy
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "main" {
  count                   = length(var.access_policies)
  key_vault_id            = var.key_vault_id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = var.access_policies[count.index].object_id
  secret_permissions      = var.access_policies[count.index].secret_permissions
  key_permissions         = var.access_policies[count.index].key_permissions
  certificate_permissions = var.access_policies[count.index].certificate_permissions
  storage_permissions     = var.access_policies[count.index].storage_permissions
}
