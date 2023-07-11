# Reference existing resource group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_monitor_action_group" "actiongroup" {
  name                = var.monitor_action_group_name
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = var.short_name

  email_receiver {
    name          = var.email-reciever-name
    email_address = var.email-address
  }

  sms_receiver {
    name         = var.sms-receiver-name
    country_code = var.country-code
    phone_number = var.phone-number

  }

  webhook_receiver {
    name        = var.webhook-receiver-name
    service_uri = var.webhook-service-uri
  }

  depends_on = [
    data.azurerm_resource_group.rg
  ]
}


resource "azurerm_monitor_metric_alert" "metricalerts" {
  name                = var.monitor_metric_alert
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [var.scopes]
  description         = "Action will be triggered when Transactions count is greater than 50."

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "Transactions"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50

    dimension {
      name     = "ApiName"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.actiongroup.id
  }
}

