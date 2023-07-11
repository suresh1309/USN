
# Reference existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name

}

# Manages a Recovery Services Vault
resource "azurerm_recovery_services_vault" "rsvault" {
  name                = var.recovery_vault_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  sku                 = var.recovery_vault_sku
  depends_on          = [data.azurerm_resource_group.main]

}

# Manages an Azure File Share Backup Policy within a Recovery Services vault
resource "azurerm_backup_policy_file_share" "fsbp" {
  name                = var.policy_file_share
  resource_group_name = data.azurerm_resource_group.main.name
  recovery_vault_name = var.recovery_vault_name
  timezone            = var.file_share_timezone
  depends_on          = [data.azurerm_resource_group.main, resource.azurerm_recovery_services_vault.rsvault]


  backup {
    frequency = "Daily"
    time      = var.file_share_time
  }

  retention_daily {
    count = var.file_share_retention
  }

  retention_weekly {
    count    = var.file_share_weekly
    weekdays = var.file_share_weekly_weekdays
  }

  retention_monthly {
    count    = var.file_share_monthly
    weekdays = var.file_share_monthly_weekdays
    weeks    = var.file_share_monthly_weeks
  }

  retention_yearly {
    count    = var.file_share_yearly
    weekdays = var.file_share_yearly_weekdays
    weeks    = var.file_share_yearly_weeks
    months   = var.file_share_yearly_months
  }

}

