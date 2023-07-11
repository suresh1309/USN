
resource "azurerm_management_group_subscription_association" "main" {
  for_each = var.association

  management_group_id = each.value.management_id
  subscription_id     = each.value.subscription_id
}