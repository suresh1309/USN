#------ logic app workflow
resource "azurerm_logic_app_workflow" "logicappwf" {
  name                = var.logic_app_workflow
  location            = var.location
  resource_group_name = var.resource_group_name
}


