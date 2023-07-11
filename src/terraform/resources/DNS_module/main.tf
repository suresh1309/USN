
resource "azurerm_dns_zone" "zone" {
  count               = var.create_zone ? 1 : 0
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
  # tags                = var.tags
}
