data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

locals {
  namelist       = split("-", data.azurerm_resource_group.resource_group.name)
  namevalidation = length(local.namelist) == 4 ? "true" : "false"
  defaultname    = local.namevalidation == "true" ? "${local.namelist[0]}-fw-${var.zone}-${var.environment}" : ""
}

resource "azurerm_firewall" "azure_firewall" {
  name                = var.firewall_name == "" ? local.defaultname : var.firewall_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  sku_tier            = var.sku_tier
  sku_name            = var.sku_name
  threat_intel_mode   = var.threat_intel_mode
  dns_servers         = var.dns_servers

  ip_configuration {
    name                 = "core-azure-firewall-config"
    subnet_id            = var.subnet_firewall_id
    public_ip_address_id = var.firewall_public_ip_id
  }
  tags = var.tags
}

# Azure Firewall Network Rule for Web access
resource "azurerm_firewall_network_rule_collection" "fw-net-web-access" {
  for_each            = { for rule in var.firewall_web_rules : rule.name => rule }
  name                = each.value.name
  azure_firewall_name = azurerm_firewall.azure_firewall.name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  rule {
    name                  = each.value.name
    source_addresses      = each.value.source_addresses
    destination_ports     = each.value.destination_ports
    destination_addresses = each.value.destination_addresses
    protocols             = each.value.protocols
  }
}
