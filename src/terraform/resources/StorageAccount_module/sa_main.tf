data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

locals {
  namelist       = split("-", data.azurerm_resource_group.resource_group.name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}sa${local.namelist[1]}${local.namelist[2]}${local.namelist[3]}${var.index}" : ""
}

resource "azurerm_storage_account" "main" {
  name                     = var.sa_name == "" ? local.defaultname : var.sa_name
  location                 = data.azurerm_resource_group.resource_group.location
  resource_group_name      = data.azurerm_resource_group.resource_group.name
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  min_tls_version          = var.min_tls_version
  lifecycle {
    prevent_destroy = false
  }
  tags = var.tags
}