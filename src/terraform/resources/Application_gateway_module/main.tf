data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

locals {
  namelist       = split("-", data.azurerm_resource_group.main.name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}-ag-${local.namelist[1]}-${local.namelist[2]}-${local.namelist[3]}" : ""

  sku_name = var.sku_name
  sku_tier = var.sku_tier
  capacity = var.capacity

  backend_address_pool_name      = "${var.appgw_name == "" ? local.defaultname : var.appgw_name}-beap"
  frontend_port_name             = "${var.appgw_name == "" ? local.defaultname : var.appgw_name}-feport"
  frontend_ip_configuration_name = "${var.appgw_name == "" ? local.defaultname : var.appgw_name}-feip"
  http_setting_name              = "${var.appgw_name == "" ? local.defaultname : var.appgw_name}-be-htst"
  listener_name                  = "${var.appgw_name == "" ? local.defaultname : var.appgw_name}-httplstn"
  request_routing_rule_name      = "${var.appgw_name == "" ? local.defaultname : var.appgw_name}-rqrt"
}

resource "azurerm_public_ip" "main" {
  name                = "${var.appgw_name == "" ? local.defaultname : var.appgw_name}-pip"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku

  tags = var.tags
}

resource "azurerm_application_gateway" "main" {
  name                = var.appgw_name == "" ? local.defaultname : var.appgw_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  enable_http2        = var.enable_http2
  zones               = var.zones
  #firewall_policy_id   = azurerm_web_application_firewall_policy.waf_policy.id

  sku {
    name     = local.sku_name
    tier     = local.sku_tier
    capacity = local.capacity
  }

  gateway_ip_configuration {
    name      = "${var.appgw_name == "" ? local.defaultname : var.appgw_name}-gatewayip"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}-public"
    public_ip_address_id = azurerm_public_ip.main.id
  }

  frontend_ip_configuration {
    name                          = "${local.frontend_ip_configuration_name}-private"
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address
    subnet_id                     = var.subnet_id
  }

  frontend_port {
    name = "${local.frontend_port_name}-80"
    port = 80
  }

  frontend_port {
    name = "${local.frontend_port_name}-443"
    port = 443
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/ping/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}-private"
    frontend_port_name             = "${local.frontend_port_name}-80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  tags = var.tags
}

# resource "azurerm_web_application_firewall_policy" "main" {
#   name                = format("%swafpolicy", lower(replace("${var.appgw_name == "" ? local.defaultname : var.appgw_name}", "/[[:^alnum:]]/", "")))
#   resource_group_name = data.azurerm_resource_group.main.name
#   location            = data.azurerm_resource_group.main.location

#   policy_settings {
#     enabled                     = var.waf_enabled
#     file_upload_limit_in_mb     = coalesce(var.waf_configuration != null ? var.waf_configuration.file_upload_limit_mb : null, 100)
#     max_request_body_size_in_kb = coalesce(var.waf_configuration != null ? var.waf_configuration.max_request_body_size_kb : null, 128)
#     mode                        = coalesce(var.waf_configuration != null ? var.waf_configuration.firewall_mode : null, "Prevention")
#     request_body_check          = true
#   }

#   dynamic "custom_rules" {
#     for_each = var.custom_policies
#     iterator = cp
#     content {
#       name      = cp.value.name
#       priority  = (cp.key + 1) * 10
#       rule_type = cp.value.rule_type
#       action    = cp.value.action

#       dynamic "match_conditions" {
#         for_each = cp.value.match_conditions
#         iterator = mc
#         content {
#           dynamic "match_variables" {
#             for_each = mc.value.match_variables
#             iterator = mv
#             content {
#               variable_name = mv.value.match_variable
#               selector      = mv.value.selector
#             }
#           }

#           operator           = mc.value.operator
#           negation_condition = mc.value.negation_condition
#           match_values       = mc.value.match_values
#         }
#       }
#     }
#   }

#   managed_rules {
#     managed_rule_set {
#       type    = coalesce(var.waf_configuration != null ? var.waf_configuration.rule_set_type : null, "OWASP")
#       version = coalesce(var.waf_configuration != null ? var.waf_configuration.rule_set_version : null, "3.1")

#       dynamic "rule_group_override" {
#         for_each = var.managed_policies_override
#         iterator = rg
#         content {
#           rule_group_name = rg.value.rule_group_name
#           disabled_rules  = rg.value.disabled_rules
#         }
#       }
#     }

#     dynamic "exclusion" {
#       for_each = var.managed_policies_exclusions
#       iterator = ex
#       content {
#         match_variable          = ex.value.match_variable
#         selector                = ex.value.selector
#         selector_match_operator = ex.value.selector_match_operator
#       }
#     }
#   }
# }

