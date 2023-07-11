provider "azurerm" {
  features {}
}

// Provide names like ["root-child1-group", "root-child2-group"]
resource "azurerm_management_group" "main" {
  count                      = length(var.names) > 0 ? length(var.names) : 0
  name                       = element(tolist(var.names), count.index)
  display_name               = element(tolist(var.names), count.index)
  parent_management_group_id = var.parent_management_id
}