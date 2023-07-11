#Terraform Statefile

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-vrk-hub-frc1"
    storage_account_name = "sttfbackendvrkhubfrc1"
    container_name       = "hubtfstatefile1"
    key                  = "hub.terraform1.tfstate"
  }
}


###################################################
# Terraform resource provisioning
###################################################
locals {

  resource_names = {
    log_rg_name                  = lower(join("-", ["rg", var.log_resource_group, var.applicationname_short, var.environment_short, var.region]))
    transit_rg_name              = lower(join("-", ["rg", var.resource_group, var.applicationname_short, var.environment_short, var.region]))
    transit_vnet_name            = lower(join("-", ["vnet", var.resource_group, var.applicationname_short, var.environment_short, var.region]))
    log_storage_account_name     = lower(join("", ["st", "log1", var.applicationname_short, var.environment_short, var.region, "01"]))
    log_analytics_workspace_name = lower(join("-", ["log", "workspace", var.applicationname_short, var.environment_short, var.region]))
    fw_pip_name                  = lower(join("-", ["pip", "fw", var.applicationname_short, var.environment_short, var.region]))
    firewall_name                = lower(join("-", ["fw", "app", var.business_unit, "dev", var.region]))
    vpn_gw_pip_name              = lower(join("-", ["pip", "vpngw", var.applicationname_short, var.environment_short, var.region]))
    vpn_gw_name                  = lower(join("-", ["vpngw", var.applicationname_short, var.environment_short, var.region]))
    jumpvm_nsg_name              = lower(join("-", ["nsg", "jumphost", var.applicationname_short, var.environment_short, var.region]))
    fw_diag_name                 = lower(join("-", ["diag-st", "fw", var.applicationname_short, var.environment_short, var.region]))
    fwpip_diag_name              = lower(join("-", ["diag-st", "fwpip", var.applicationname_short, var.environment_short, var.region]))
    vpnpip_diag_name             = lower(join("-", ["diag-st", "vpnpip", var.applicationname_short, var.environment_short, var.region]))
    jumpvmnnsg_diag_name         = lower(join("-", ["diag-st", "jumpvmnsg", var.applicationname_short, var.region, var.environment_short, ]))
    jumpvmnsg_nw_name            = lower(join("-", ["nw", "jumpvmnsg", var.applicationname_short, var.environment_short, var.region]))
    keyvault_name                = lower(join("-", ["kv", "app", var.applicationname_short, "dev", var.region]))
    jumpvm1_nic_name             = lower(join("-", ["nic", "jumphost", var.applicationname_short, var.environment_short, var.region, "001"]))
    jumpvm1_vm_name              = lower(join("-", ["vm", "jumphost", var.applicationname_short, var.environment_short, var.region, "001"]))
    jumpvm2_nic_name             = lower(join("-", ["nic", "jumphost", var.applicationname_short, var.environment_short, var.region, "002"]))
    jumpvm2_vm_name              = lower(join("-", ["vm", "jumphost", var.applicationname_short, var.environment_short, var.region, "002"]))
    jumpvm_private_endpoint_name = lower(join("-", ["pe", "jumpvm-Subnet", "logstorageaccount", var.environment_short, var.region]))
    route_table_name             = lower(join("-", ["route", "app", var.applicationname_short, var.environment_short, var.region]))
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
# Log resource provisioning
###################################################

#This module creates Log Resource Group in Hub Environment. 
#This Resource Group required to deploy Storage account and Log Analytics WorkSpace

module "azurerm_rg_log" {
  source   = "../resources/ResourceGroup_module"
  name     = local.resource_names.log_rg_name
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", local.resource_names.log_rg_name) }, local.tags)
}

#This module creates Storage account in Hub Environment. 
#This storage Account required to save all Logs

module "azurerm_log_storage_account" {
  source              = "../resources/StorageAccount_module"
  sa_name             = local.resource_names.log_storage_account_name
  resource_group_name = module.azurerm_rg_log.resource_group_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.log_storage_account_name) }, local.tags)
  depends_on          = [module.azurerm_rg_log]
}

#This module creates Log analytics workspace in Hub Environment. 
#This Log Analytics WorkSpace helps in saving all logs in to storage account

module "azure_loganalyticsworkspace" {
  source              = "../resources/Log_analytics_workspace"
  law_name            = local.resource_names.log_analytics_workspace_name
  resource_group_name = module.azurerm_rg_log.resource_group_name
  retention_in_days   = var.retention_in_days
  log_analytics_sku   = var.log_analytics_sku
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.log_analytics_workspace_name) }, local.tags)
  depends_on          = [module.azurerm_log_storage_account]
}

#This module creates Transit Resource Group in Hub Environment. 
#This Resource Group required to deploy vnet, Subnets, Firewall, VPN Gateway and JumpHostVM's in it.

module "azurerm_rg_transit" {
  source   = "../resources/ResourceGroup_module"
  name     = local.resource_names.transit_rg_name
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", local.resource_names.transit_rg_name) }, local.tags)
}

#This module creates Transit Virtual Network in Hub Environment.
#This Virtual Network required to deploy Subnets, Firewall, VPN Gateway and JumpHostVM's.

module "azurerm_vnet_transit" {
  source              = "../resources/VNet_module"
  resource_group_name = module.azurerm_rg_transit.resource_group_name
  name                = local.resource_names.transit_vnet_name
  addressSpace        = var.vnet_transit_addressspace
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.transit_vnet_name) }, local.tags)
  depends_on          = [module.azurerm_rg_transit]
}

#This module creates Subnet in Transit Virtual Network for Hub Environment.
#This subnet required to host Azure Firewall

# module "azurerm_snet_firewall" {
#   source               = "../resources/SubNet_module"
#   resource_group_name  = module.azurerm_rg_transit.resource_group_name
#   name                 = var.firewall_subnet_name
#   subnet_addressSpaces = var.snet_firewall_addressspaces
#   virtual_network_name = module.azurerm_vnet_transit.virtual_network_name
#   depends_on           = [module.azurerm_vnet_transit]
# }

# This Module creates Public IP in Transit Resource Group for Hub Environment.
# This IP is required to configure with VPN Gateway

# module "firewall_public_ip" {
#   source              = "../resources/PublicIP_module"
#   name                = local.resource_names.fw_pip_name
#   resource_group_name = module.azurerm_rg_transit.resource_group_name
#   sku                 = var.firewall_pip_sku
#   allocation_method   = var.firewall_pip_allocation_method
#   tags                = merge({ "ResourceName" = format("%s", local.resource_names.fw_pip_name) }, local.tags)
#   depends_on          = [module.azurerm_snet_firewall]
# }

# This module helps in creating Azure Firewall in Transit Resource Group for Hub Environment
# This Azure Firewall in Hub Environment for Connectivity

# module "azure_firewall" {
#   source                = "../resources/Firewall_module"
#   firewall_name         = local.resource_names.firewall_name
#   location              = var.location
#   resource_group_name   = module.azurerm_rg_transit.resource_group_name
#   virtual_network_name  = module.azurerm_vnet_transit.virtual_network_name
#   subnet_firewall_id    = module.azurerm_snet_firewall.subnet_id
#   firewall_public_ip_id = module.firewall_public_ip.id
#   threat_intel_mode     = var.threat_intel_mode
#   firewall_web_rules    = var.firewall_web_rules
#   tags                  = merge({ "ResourceName" = format("%s", local.resource_names.firewall_name) }, local.tags)
#   depends_on            = [module.firewall_public_ip, module.azurerm_snet_firewall]
# }

# # This module helps in Diagnosis settings for Firewall
# module "azure_diagnosticsettings_firewall" {
#   source              = "../resources/Diagnostic_Settings"
#   diag_name           = local.resource_names.fw_diag_name
#   resource_group_name = module.azurerm_rg_transit.resource_group_name
#   destination         = module.azure_loganalyticsworkspace.log_analytics_workspace_id
#   target_ids          = [module.azure_firewall.firewall_id]
#   storage_account_id  = module.azurerm_log_storage_account.storage_account_id
#   logs = [
#     "AzureFirewallApplicationRule",
#     "AzureFirewallNetworkRule",
#     "AzureFirewallDnsProxy"
#   ]
#   tags = merge({ "ResourceName" = format("%s", local.resource_names.fw_diag_name) }, local.tags)
#   depends_on = [
#     module.azurerm_log_storage_account,
#     module.azure_firewall,
#     module.azure_loganalyticsworkspace
#   ]
# # }
# # This module helps in Diagnosis settings for Firewall Public Ip
# module "azure_diagnosticsettings_fwpips" {
#   source              = "../resources/Diagnostic_Settings"
#   diag_name           = local.resource_names.fwpip_diag_name
#   destination         = module.azure_loganalyticsworkspace.log_analytics_workspace_id
#   resource_group_name = module.azurerm_rg_transit.resource_group_name
#   target_ids          = [module.firewall_public_ip.id]
#   storage_account_id  = module.azurerm_log_storage_account.storage_account_id
#   logs = [
#     "DDoSProtectionNotifications",
#     "DDoSMitigationFlowLogs",
#     "DDoSMitigationReports"
#   ]

#   tags = merge({ "ResourceName" = format("%s", local.resource_names.fwpip_diag_name) }, local.tags)
#   depends_on = [

#     module.azurerm_log_storage_account,
#     module.firewall_public_ip,
#     module.azure_firewall,
#     module.azure_loganalyticsworkspace,
#     module.azure_diagnosticsettings_firewall
#   ]
# }


###################################################
# VPN Gateway resources provisioning
###################################################

#This module creates Subnet in Transit Virtual Network for Hub Environment.
#This subnet required to host VPN gateway

# module "azurerm_snet_vpn_gateway" {
#   source               = "../resources/SubNet_module"
#   resource_group_name  = module.azurerm_rg_transit.resource_group_name
#   name                 = "GatewaySubnet" #VPN gateway subnet name must be "GatewaySubnet"
#   subnet_addressSpaces = var.snet_vpn_gateway_addressspaces
#   virtual_network_name = module.azurerm_vnet_transit.virtual_network_name
#   depends_on = [

#     module.azurerm_vnet_transit,
#     module.azure_firewall,
#     module.azure_diagnosticsettings_fwpips
#   ]
# }

# This Module creates Public IP in Transit Resource Group for Hub Environment
# This IP is required to configure with VPN Gateway

# module "vpn_gateway_public_ip" {
#   source              = "../resources/PublicIP_module"
#   name                = local.resource_names.vpn_gw_pip_name
#   resource_group_name = module.azurerm_rg_transit.resource_group_name
#   sku                 = var.vpn_gateway_pip_sku
#   allocation_method   = var.vpn_gateway_pip_allocation_method
#   tags                = merge({ "ResourceName" = format("%s", local.resource_names.vpn_gw_pip_name) }, local.tags)
#   depends_on          = [module.azurerm_snet_vpn_gateway]
# }

# #This module creates VPN Gateway in Transit Resource Group for Hub Environment.
# # VPN Gateway is for Secure connection for Spoke Environement.

# module "azure_vpn_gateway" {
#   source                = "../resources/Virtual_Network_Gateway"
#   name                  = local.resource_names.vpn_gw_name
#   resource_group_name   = module.azurerm_rg_transit.resource_group_name
#   sku                   = var.vpn_gateway_sku
#   private_ip_allocation = var.vpn_gateway_private_IP_allocation
#   azurerm_subnet        = module.azurerm_snet_vpn_gateway.subnet_id
#   azurerm_public_ip     = module.vpn_gateway_public_ip.id
#   tags                  = merge({ "ResourceName" = format("%s", local.resource_names.vpn_gw_name) }, local.tags)
#   depends_on = [
#     module.azurerm_snet_vpn_gateway,
#     module.vpn_gateway_public_ip,
#   ]
# }
# This module helps in Diagnosis settings for VPN Public IP
# module "azure_diagnosticsettings_vpnpip" {
#   source              = "../resources/Diagnostic_Settings"
#   diag_name           = local.resource_names.vpnpip_diag_name
#   destination         = module.azure_loganalyticsworkspace.log_analytics_workspace_id
#   resource_group_name = module.azurerm_rg_transit.resource_group_name
#   target_ids          = [module.vpn_gateway_public_ip.id]
#   storage_account_id  = module.azurerm_log_storage_account.storage_account_id
#   logs = [
#     "DDoSProtectionNotifications",
#     "DDoSMitigationFlowLogs",
#     "DDoSMitigationReports"
#   ]
#   tags = merge({ "ResourceName" = format("%s", local.resource_names.vpnpip_diag_name) }, local.tags)
#   depends_on = [
#     module.azurerm_log_storage_account,
#     module.azure_loganalyticsworkspace,
#     module.azure_vpn_gateway,
#     module.vpn_gateway_public_ip
#   ]
# }

###################################################
# Key Vault provisioning
###################################################
data "azurerm_client_config" "main" {}

module "keyvault" {
  source                          = "../resources/KeyVault_module"
  name                            = local.resource_names.keyvault_name
  resource_group_name             = module.azurerm_rg_transit.resource_group_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  tags                            = merge({ "ResourceName" = format("%s", local.resource_names.keyvault_name) }, local.tags)

  depends_on          = [module.azurerm_rg_transit]
}
# This resources helps in creating Random Password for Key Secret for Jumphost VM1 
resource "random_password" "jumpvm1" {
  length     = 20
  special    = true
  depends_on = [module.keyvault]
}
# This resources helps in creating Keyvault Secret to Jumphost VM1 
resource "azurerm_key_vault_secret" "jumpvm1" {
  name         = var.vm1secret_name
  value        = random_password.jumpvm1.result
  key_vault_id = module.keyvault.id
  depends_on   = [module.keyvault, random_password.jumpvm1]
}
# This resources helps in creating Random Password for Key Secret for Jumphost VM2 
# resource "random_password" "jumpvm2" {
#   length     = 20
#   special    = true
#   depends_on = [module.keyvault]
# }
# This resources helps in creating Keyvault Secret to Jumphost VM2 
# resource "azurerm_key_vault_secret" "jumpvm2" {
#   name         = var.vm2secret_name
#   value        = random_password.jumpvm2.result
#   key_vault_id = module.keyvault.id
#   depends_on   = [module.keyvault, random_password.jumpvm2]
#  }
# # This Module helps in creating Keyvault Policy to view the  Secrets
# module "keyvault_policy" {
#   source          = "../resources/Key_vault_multi_access_policy"
#   key_vault_id    = module.keyvault.id
#   access_policies = var.access_policies
#   depends_on      = [module.keyvault.id]
# }
###################################################
# Jump Host VM'S resources provisioning
###################################################

# This module helps in creating Subnet in Transit Resource Group for Hub Environemnt
# This Subnet is required to host Jump Host VM

module "azurerm_snet_jumpvm" {
  source               = "../resources/SubNet_module"
  resource_group_name  = module.azurerm_rg_transit.resource_group_name
  name                 = var.jumpvm_subnet_name
  subnet_addressSpaces = var.snet_jumpvm_addressspaces
  virtual_network_name = module.azurerm_vnet_transit.virtual_network_name
  depends_on = [
    module.keyvault,
    module.azurerm_vnet_transit,
    
  ]
}

# This module helps in creating Network Security Group in Transit Resource Group for Hub Environemnt
# This NSG is required to restrict traffic to Jump Host VM's
# Due to security best practices, All Inbound & OutBound DENY Rules were applied for all NSG's. 
# In Build Phase please implement the required rules that's necessary

module "azurerm_nsg_jumpvm" {
  source              = "../resources/NetworkSecurityGroup_module"
  resource_group_name = module.azurerm_rg_transit.resource_group_name
  name                = local.resource_names.jumpvm_nsg_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.jumpvm_nsg_name) }, local.tags)
  depends_on          = [module.azurerm_snet_jumpvm]
  rules = [
    {
      name                       = "Deny_Inbound"
      priority                   = "200"
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_ranges         = "*"
      destination_port_ranges    = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "All InBound Deny"
    },
    {
      name                       = "Deny_Outbound"
      priority                   = "200"
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_ranges         = "*"
      destination_port_ranges    = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "All OutBound Deny"
    }
  ]

}

# This module helps in associating Subnet with Network Security Group.
# This NSG and Subnet Association is required to restrict traffic to Jump Host VM's

# module "azurerm_nsg_jumpvm_assoc" {
#   source                    = "../resources/Subnet_NSG_association_module"
#   subnet_id                 = module.azurerm_snet_jumpvm.subnet_id
#   network_security_group_id = module.azurerm_nsg_jumpvm.network_security_group_id
#   depends_on                = [module.azurerm_nsg_jumpvm, module.azurerm_snet_jumpvm]
# }

# # This module helps in Diagnosis settings for Jump Vm NSG 
# resource "azurerm_monitor_diagnostic_setting" "jumpvmnnsg" {
#   name               = local.resource_names.jumpvmnnsg_diag_name
#   target_resource_id = module.azurerm_nsg_jumpvm.network_security_group_id
#   storage_account_id = module.azurerm_log_storage_account.storage_account_id

#   log {
#     category = "NetworkSecurityGroupEvent"
#     enabled  = true

#     retention_policy {
#       enabled = false
#     }
#   }
#   depends_on = [
#     module.azure_loganalyticsworkspace,
#     module.azurerm_log_storage_account,
#     module.azurerm_nsg_jumpvm_assoc
#   ]
# }
# # This module helps in creating NSG Flow Logs of Jump Vm NSG 
# resource "azurerm_network_watcher_flow_log" "nsgfl-jumpvm" {
#   network_watcher_name = "NetworkWatcher_francecentral"
#   resource_group_name  = "NetworkWatcherRG"

#   network_security_group_id = module.azurerm_nsg_jumpvm.network_security_group_id
#   storage_account_id        = module.azurerm_log_storage_account.storage_account_id
#   enabled                   = true
#   version                   = 2

#   retention_policy {
#     enabled = true
#     days    = 7
#   }

#   traffic_analytics {
#     enabled               = true
#     workspace_id          = module.azure_loganalyticsworkspace.log_analytics_workspace_id
#     workspace_region      = var.location
#     workspace_resource_id = module.azure_loganalyticsworkspace.log_analytics_resource_id
#     interval_in_minutes   = 10
#   }
#   depends_on = [
#     module.azure_loganalyticsworkspace,
#     module.azurerm_nsg_jumpvm,
#     module.azurerm_log_storage_account,
#     azurerm_monitor_diagnostic_setting.jumpvmnnsg
#   ]
# }


# This module helps in creating Jump Host VM 01 in Transit Resource Group for Hub Environemnt
# This Jump Host VM 01 helps in private remote connection with Spoke Environment. 

module "azurerm_jumpvm01" {
  source              = "../resources/AZ_Windows_VM"
  nic_name            = local.resource_names.jumpvm1_nic_name
  vm_name             = local.resource_names.jumpvm1_vm_name
  resource_group_name = module.azurerm_rg_transit.resource_group_name
  ip_config_name      = var.jumpvm1_ip_config_name
  subnet_id           = module.azurerm_snet_jumpvm.subnet_id
  vm_size             = var.vm_size
  os_disk_name        = var.jumpvm1_os_disk_name
  caching             = var.caching
  create_option       = var.create_option
  managed_disk_type   = var.managed_disk_type
  i_offer             = var.i_offer
  i_publisher         = var.i_publisher
  i_sku               = var.i_sku
  i_version           = var.i_version
  computer_name       = var.vm1_computer_name
  admin_username      = var.vm1_admin_username
  admin_password      = azurerm_key_vault_secret.jumpvm1.value
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.jumpvm1_vm_name) }, local.tags)
  depends_on = [
    azurerm_key_vault_secret.jumpvm1,
    
    module.azurerm_snet_jumpvm
  ]
}

# This module helps in creating Jump Host VM 02 in Transit Resource Group for Hub Environemnt
# This Jump Host VM 02 helps in private remote connection with Spoke Environment. 

# module "azurerm_jumpvm02" {
#   source              = "../resources/AZ_Windows_VM"
#   nic_name            = local.resource_names.jumpvm2_nic_name
#   vm_name             = local.resource_names.jumpvm2_vm_name
#   resource_group_name = module.azurerm_rg_transit.resource_group_name
#   ip_config_name      = var.jumpvm2_ip_config_name
#   subnet_id           = module.azurerm_snet_jumpvm.subnet_id
#   vm_size             = var.vm_size
#   os_disk_name        = var.jumpvm2_os_disk_name
#   caching             = var.caching
#   create_option       = var.create_option
#   managed_disk_type   = var.managed_disk_type
#   i_offer             = var.i_offer
#   i_publisher         = var.i_publisher
#   i_sku               = var.i_sku
#   i_version           = var.i_version
#   computer_name       = var.vm2_computer_name
#   admin_username      = var.vm2_admin_username
#   admin_password      = azurerm_key_vault_secret.jumpvm2.value
#   tags                = merge({ "ResourceName" = format("%s", local.resource_names.jumpvm2_vm_name) }, local.tags)

#   depends_on = [
#     azurerm_key_vault_secret.jumpvm2,
   
#     module.azurerm_snet_jumpvm,
#     module.azurerm_jumpvm01
#   ]
# }

# This module helps in creating Route Table in Transit Resource Group for Hub Environemnt
# This Route Table helps user defined routing and by creating network routes so that firewall can handle inbound & Outbound traffic 

module "azurerm_route_table" {
  source              = "../resources/Route_table_module"
  resource_group_name = module.azurerm_rg_transit.resource_group_name
  name                = local.resource_names.route_table_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.route_table_name) }, local.tags)
  depends_on          = [module.azurerm_rg_transit]
}

# This module helps in associating Route Table to Subnet

# module "azurerm_snet_firewall_route_table_association" {
#   source         = "../resources/Subnet_route_table_association_module"
#   subnet_id      = module.azurerm_snet_firewall.subnet_id
#   route_table_id = module.azurerm_route_table.route_table_id
#   depends_on     = [module.azurerm_route_table, module.azurerm_snet_firewall]
# }

#This module helps in creating Private End Point in Jump Host Subnet.
#This Private End Point helps in private connection to Storage Account

# module "azurerm_jumpvm_private_endpoint" {
#   source                           = "../resources/Private_Endpoint"
#   location                         = var.location
#   private_endpoint_name            = local.resource_names.jumpvm_private_endpoint_name
#   resource_group_name              = module.azurerm_rg_transit.resource_group_name
#   subnet_id                        = module.azurerm_snet_jumpvm.subnet_id
#   private_connection_name          = var.private_connection_name
#   private_link_enabled_resource_id = module.azurerm_log_storage_account.storage_account_id
#   subresource_names                = var.subresource_names
#   depends_on = [
#     module.azurerm_nsg_jumpvm,
#     module.azurerm_log_storage_account,
#     module.azurerm_route_table
#   ]

# }
