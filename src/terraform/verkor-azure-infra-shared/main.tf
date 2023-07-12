#Terraform Statefile

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-usn-shared-frc-33"
    storage_account_name = "sttfbackendusn3sharedfrc"
    container_name       = "usnterraformspn"
    key                  = "usn.terra.tfstate"
  }
}


###################################################
# Terraform resource provisioning
###################################################

locals {

  resource_names = {
    shared_rg_name      = lower(join("-", ["rg", "usn", var.applicationname_short, var.environment_short, var.region]))
    shared_rsv_name     = lower(join("-", ["rsv", "usn", var.applicationname_short, var.environment_short, var.region]))
    shared_storage_name = lower(join("", ["st", "usn", var.applicationname_short, var.environment_short, var.region, "1"]))
  }

  tags = {
    Customer           = var.customer
    Category           = var.category
    BusinessUnit       = var.business_unit
    ApplicationName    = var.applicationname
    DataClassification = var.data_classification
    ApproverName       = var.approver_name
    Environment        = var.environment
    OwnerName          = var.owner_name
    Contact            = var.contact
    Region             = var.region
  }
}

###################################################
# Spoke resource provisioning
###################################################

#This module creates shared Resource Group.
#This Resource Group Host, Monitor, Keyvault and other services

module "azurerm_rg_shared" {
  source   = "../resources/ResourceGroup_module"
  name     = local.resource_names.shared_rg_name
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", local.resource_names.shared_rg_name) }, local.tags)
}

#This module creates Recovery Serice Vault.

module "azurerm_recovery_service_vault" {
  source                      = "../resources/RSV_Backup_module"
  resource_group_name         = module.azurerm_rg_shared.resource_group_name
  location                    = var.location
  create_rsvault              = var.create_rsvault
  region                      = var.region
  environment                 = var.environment
  recovery_vault_name         = var.recovery_vault_name
  recovery_vault_sku          = var.recovery_vault_sku
  policy_file_share           = var.policy_file_share
  file_share_timezone         = var.file_share_timezone
  file_share_time             = var.file_share_time
  file_share_retention        = var.file_share_retention
  file_share_weekly           = var.file_share_weekly
  file_share_monthly          = var.file_share_monthly
  file_share_yearly           = var.file_share_yearly
  file_share_weekly_weekdays  = var.file_share_weekly_weekdays
  file_share_monthly_weekdays = var.file_share_monthly_weekdays
  file_share_monthly_weeks    = var.file_share_monthly_weeks
  file_share_yearly_weekdays  = var.file_share_yearly_weekdays
  file_share_yearly_weeks     = var.file_share_yearly_weeks
  file_share_yearly_months    = var.file_share_yearly_months
  tags                        = merge({ "ResourceName" = format("%s", local.resource_names.shared_rsv_name) }, local.tags)
  depends_on                  = [module.azurerm_rg_shared.id]
}

#This module creates Storage Account in Shared Subscription

module "azurerm_storage_shared" {
  source              = "../resources/StorageAccount_module"
  sa_name             = local.resource_names.shared_storage_name
  resource_group_name = module.azurerm_rg_shared.resource_group_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.shared_storage_name) }, local.tags)
  depends_on          = [module.azurerm_rg_shared]
}

#This module creates Azure Monitor in Shared Subscription

module "azurerm_monitor" {
  source                    = "../resources/Azure_monitor"
  resource_group_name       = module.azurerm_rg_shared.resource_group_name
  location                  = var.location
  scopes                    = module.azurerm_storage_shared.storage_account_id
  monitor_action_group_name = var.monitor_action_group_name
  webhook-receiver-name     = var.webhook-receiver-name
  webhook-service-uri       = var.webhook-service-uri
  short_name                = var.short_name
  sms-receiver-name         = var.sms-receiver-name
  country-code              = var.country-code
  phone-number              = var.phone-number
  email-reciever-name       = var.email-reciever-name
  email-address             = var.email-address
  storage                   = module.azurerm_storage_shared.storage-account-name
  monitor_metric_alert      = var.monitor_metric_alert
  depends_on                = [module.azurerm_storage_shared.id, module.azurerm_rg_shared.id]

}

#This module creates DNS in Shared Subscription

module "dns_module" {
  source              = "../resources/DNS_module"
  resource_group_name = module.azurerm_rg_shared.resource_group_name
  dns_zone_name       = var.dns_zone_name
  location            = var.location
  region              = var.region
  create_zone         = var.create_zone
  tag_dns_zone_name   = var.dns_zone_name
}

#This module creates Verkor-Administator AD Group and associate its members.
/*

module "azurerm_ad_administrator" {
  source        = "../resources/Azuread_groups_users"
  adgroup_name  = var.admin_adgroup_name
  group_members = var.admin_adgroup_users
}

#This module creates Verkor-Devops AD Group and associate its members.

module "azurerm_ad_devops" {
  source        = "../resources/Azuread_groups_users"
  adgroup_name  = var.devops_adgroup_name
  group_members = var.devops_adgroup_users
}

#This module creates Verkor-Readers AD Group and associate its members.

module "azurerm_ad_reader" {
  source        = "../resources/Azuread_groups_users"
  adgroup_name  = var.reader_adgroup_name
  group_members = var.reader_adgroup_users
}

#This module creates Verkor-Useraccessadmin AD Group and associate its members.

module "azurerm_ad_useraccessadmin" {
  source        = "../resources/Azuread_groups_users"
  adgroup_name  = var.useraccessadmin_adgroup_name
  group_members = var.useraccessadmin_adgroup_users
}

#This module creates Verkor-Developers AD Group and associate its members.

module "azurerm_ad_developer" {
  source        = "../resources/Azuread_groups_users"
  adgroup_name  = var.developer_adgroup_name
  group_members = var.developer_adgroup_users
}

#This module creates Verkor-DevOps-Approver AD Group and associate its members.

module "azurerm_ad_devops_approver" {
  source        = "../resources/Azuread_groups_users"
  adgroup_name  = var.devops_approver_adgroup_name
  group_members = var.devops_approver_adgroup_users
}

#This module creates Verkor-Reader AD Group and associate its members.

module "azurerm_ad_security" {
  source        = "../resources/Azuread_groups_users"
  adgroup_name  = var.security_adgroup_name
  group_members = var.security_adgroup_users
}
*/
