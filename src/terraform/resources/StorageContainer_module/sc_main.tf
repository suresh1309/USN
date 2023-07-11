terraform {
  required_version = "0.12.6"
}

provider "azurerm" {
  version = "1.32.0"
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

locals {
  namelist           = split("-", data.azurerm_resource_group.main.name)
  namevalidation     = length(local.namelist) == 4 ? "true" : "false"
  storageaccountname = local.namevalidation == "true" ? "${local.namelist[0]}sa${local.namelist[1]}${local.namelist[2]}${local.namelist[3]}${var.index}" : ""
}

resource "azurerm_storage_container" "main" {
  name                 = var.name
  resource_group_name  = data.azurerm_resource_group.main.name
  storage_account_name = var.storageaccountname == "" ? local.storageaccountname : var.storageaccountname

  lifecycle {
    prevent_destroy = true
  }
}
