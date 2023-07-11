data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

locals {
  namelist           = split("-", data.azurerm_resource_group.resource_group.name)
  namevalidation     = length(local.namelist) == 4 ? "true" : "false"
  defaultname        = local.namevalidation == "true" ? "${local.namelist[0]}-DiagnosticSetting-${var.zone}-${var.environment}" : ""
  diag_resource_list = split("/", var.destination)
  log_analytics_id   = contains(local.diag_resource_list, "microsoft.operationalinsights") ? var.destination : null
  storage_account_id = contains(local.diag_resource_list, "Microsoft.Storage") ? var.destination : null
  event_hub_auth_id  = contains(local.diag_resource_list, "Microsoft.EventHub") ? var.destination : null
}

resource "azurerm_monitor_diagnostic_setting" "main" {
  count                          = length(var.target_ids)
  name                           = var.diag_name == "" ? local.defaultname : var.diag_name
  target_resource_id             = var.target_ids[count.index]
  log_analytics_workspace_id     = local.log_analytics_id
  eventhub_authorization_rule_id = local.event_hub_auth_id
  eventhub_name                  = local.event_hub_auth_id != null ? var.eventhub_name : null
  storage_account_id             = var.storage_account_id

  dynamic "log" {
    for_each = var.logs
    content {
      category = log.value
      enabled  = true
      retention_policy {
        enabled = var.retention_policy_log_enable
        days    = var.retention_days
      }
    }
  }

}
