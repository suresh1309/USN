#Terraform Statefile

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-vrk-qa-frc"
    storage_account_name = "sttfbackendvrkqafrc"
    container_name       = "qatfstatefile"
    key                  = "qa.terraform.tfstate"
  }
}


###################################################
# Pulling existing Resources from Hub Subscription
###################################################
data "azurerm_storage_account" "log" {
  provider            = azurerm.Hub-Env
  name                = "stlogvrkhubfrc001"
  resource_group_name = "rg-log-vrk-hub-frc"
}
data "azurerm_virtual_network" "hubvnet" {
  provider            = azurerm.Hub-Env
  name                = "vnet-transit-vrk-hub-frc"
  resource_group_name = "rg-transit-vrk-hub-frc"
}
data "azurerm_log_analytics_workspace" "laws" {
  provider            = azurerm.Hub-Env
  name                = "log-workspace-vrk-hub-frc"
  resource_group_name = "rg-log-vrk-hub-frc"
}

###################################################
# Terraform resource provisioning
###################################################

locals {

  resource_names = {
    spoke_rg_name                     = lower(join("-", ["rg", "app", var.applicationname_short, var.environment_short, var.region]))
    spoke_vnet_name                   = lower(join("-", ["vnet", var.environment_short, var.applicationname_short, var.region, "001"]))
    front_snet_name                   = lower(join("-", ["snet", "front", var.applicationname_short, var.environment_short, var.region]))
    front_nsg_name                    = lower(join("-", ["nsg", "front", var.applicationname_short, var.environment_short, var.region]))
    dataingest_snet_name              = lower(join("-", ["snet", "dataingest", var.applicationname_short, var.environment_short, var.region]))
    dataingest_nsg_name               = lower(join("-", ["nsg", "dataingest", var.applicationname_short, var.environment_short, var.region]))
    dataingest_rt_name                = lower(join("-", ["rt", "dataingest", var.applicationname_short, var.environment_short, var.region]))
    appgw_snet_name                   = lower(join("-", ["snet", "appgw", var.applicationname_short, var.environment_short, var.region]))
    appgw_name                        = lower(join("-", ["agw", "app", var.applicationname_short, var.environment_short, var.region]))
    appgw_rt_name                     = lower(join("-", ["rt", "appgw", var.applicationname_short, var.environment_short, var.region]))
    appgw_nsg_name                    = lower(join("-", ["nsg", "appgw", var.applicationname_short, var.environment_short, var.region]))
    dataprocess_snet_name             = lower(join("-", ["snet", "dataprocess", var.applicationname_short, var.environment_short, var.region]))
    dataprocess_nsg_name              = lower(join("-", ["nsg", "dataprocess", var.applicationname_short, var.environment_short, var.region]))
    dataprocess_private_endpoint_name = lower(join("-", ["pe", "dataproc-Subnet", "logst", var.environment_short, var.region]))
    frontnsg_diag_name                = lower(join("-", ["diag-st", "frontnsg", var.applicationname_short, var.region, var.environment_short, ]))
    dinsg_diag_name                   = lower(join("-", ["diag-st", "di", var.applicationname_short, var.region, var.environment_short, ]))
    appgwnsg_diag_name                = lower(join("-", ["diag-st", "appgw", var.applicationname_short, var.region, var.environment_short, ]))
    dpnsg_diag_name                   = lower(join("-", ["diag-st", "dp", var.applicationname_short, var.region, var.environment_short, ]))

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
# Hub resource provisioning
###################################################

#This module creates SPOKE Resource Group in Hub Environment. 
#This Resource Group required to deploy vnet, Subnets, Firewall, VPN Gateway and JumpHostVM's in it.

module "azurerm_rg_spoke" {
  source   = "../resources/ResourceGroup_module"
  name     = local.resource_names.spoke_rg_name
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", local.resource_names.spoke_rg_name) }, local.tags)
}

#This module creates spoke Virtual Network in Hub Environment.
#This Virtual Network required to deploy Subnets, Firewall, VPN Gateway and JumpHostVM's.

module "azurerm_vnet_spoke" {
  source              = "../resources/VNet_module"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  name                = local.resource_names.spoke_vnet_name
  addressSpace        = var.vnet_spoke_addressspace
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.spoke_vnet_name) }, local.tags)
  depends_on          = [module.azurerm_rg_spoke]
}

###################################################
# FRONT END subnet provisioning
###################################################

# This module creates Subnet in spoke Virtual Network for SPOKE Environment.
# This subnet act as FRONT END Subnet

module "azurerm_snet_front" {
  source               = "../resources/SubNet_module"
  resource_group_name  = module.azurerm_rg_spoke.resource_group_name
  name                 = local.resource_names.front_snet_name
  subnet_addressSpaces = var.snet_front_addressspaces
  virtual_network_name = module.azurerm_vnet_spoke.virtual_network_name
  depends_on           = [module.azurerm_vnet_spoke]
}

# This module helps in creating Network Security Group in SPOKE Resource Group for Front Subnet
# This NSG is required to restrict traffic to Front Subnet
# Due to security best practices, All Inbound & OutBound DENY Rules were applied for all NSG's. 
# In Build Phase please implement the required rules that's necessary

module "azurerm_nsg_front" {
  source              = "../resources/NetworkSecurityGroup_module"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  name                = local.resource_names.front_nsg_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.front_nsg_name) }, local.tags)
  depends_on          = [module.azurerm_snet_front]
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
# This NSG and Subnet Association is required to restrict traffic to Front End subnet

module "azurerm_nsg_front_assoc" {
  source                    = "../resources/Subnet_NSG_association_module"
  subnet_id                 = module.azurerm_snet_front.subnet_id
  network_security_group_id = module.azurerm_nsg_front.network_security_group_id
  depends_on                = [module.azurerm_nsg_front, module.azurerm_snet_front]
}

# This module helps in creating Diagnosis settings for "FRONTEND NSG"

module "azure_diagnosticsettings_frontnsg" {
  source              = "../resources/NSG_Diagnostic_Settings"
  diag_name           = local.resource_names.frontnsg_diag_name
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  destination         = data.azurerm_log_analytics_workspace.laws.id
  target_ids          = [module.azurerm_nsg_front.network_security_group_id]
  storage_account_id  = data.azurerm_storage_account.log.id
  logs = [
    "NetworkSecurityGroupEvent",
    "NetworkSecurityGroupRuleCounter"
  ]
  tags = merge({ "ResourceName" = format("%s", local.resource_names.frontnsg_diag_name) }, local.tags)
  depends_on = [
    module.azurerm_nsg_front
  ]
}
# This module helps in creating NSG Flow Logs for "FRONTEND NSG"

resource "azurerm_network_watcher_flow_log" "frontnsg" {
  network_watcher_name = "NetworkWatcher_francecentral"
  resource_group_name  = "NetworkWatcherRG"

  network_security_group_id = module.azurerm_nsg_front.network_security_group_id
  storage_account_id        = data.azurerm_storage_account.log.id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.laws.workspace_id
    workspace_region      = var.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.laws.id
    interval_in_minutes   = 10
  }
  depends_on = [module.azurerm_nsg_front]

}

###################################################
# Data Ingest  resources provisioning
###################################################

# This module creates Subnet in spoke Virtual Network for SPOKE Environment.
# This subnet act as Data Ingest Subnet

module "azurerm_snet_dataingest" {
  source               = "../resources/SubNet_module"
  resource_group_name  = module.azurerm_rg_spoke.resource_group_name
  name                 = local.resource_names.dataingest_snet_name
  subnet_addressSpaces = var.snet_dataingest_addressspaces
  virtual_network_name = module.azurerm_vnet_spoke.virtual_network_name
  depends_on           = [module.azurerm_vnet_spoke]
}

# This module helps in creating Network Security Group in SPOKE Resource Group for Front Subnet
# This NSG is required to restrict traffic to Front Subnet
# Due to security best practices, All Inbound & OutBound DENY Rules were applied for all NSG's. 
# In Build Phase please implement the required rules that's necessary

module "azurerm_nsg_dataingest" {
  source              = "../resources/NetworkSecurityGroup_module"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  name                = local.resource_names.dataingest_nsg_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.dataingest_nsg_name) }, local.tags)
  depends_on          = [module.azurerm_snet_dataingest]
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
# This NSG and Subnet Association is required to restrict traffic to Front End subnet

module "azurerm_nsg_dataingest_assoc" {
  source                    = "../resources/Subnet_NSG_association_module"
  subnet_id                 = module.azurerm_snet_dataingest.subnet_id
  network_security_group_id = module.azurerm_nsg_dataingest.network_security_group_id
  depends_on                = [module.azurerm_snet_dataingest, module.azurerm_nsg_dataingest]
}

# This module helps in creating Diagnosis settings for "DATAINGEST NSG"

module "azure_diagnosticsettings_ingestnsg" {
  source              = "../resources/NSG_Diagnostic_Settings"
  diag_name           = local.resource_names.dinsg_diag_name
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  destination         = data.azurerm_log_analytics_workspace.laws.id
  target_ids          = [module.azurerm_nsg_dataingest.network_security_group_id]
  storage_account_id  = data.azurerm_storage_account.log.id
  logs = [
    "NetworkSecurityGroupEvent",
    "NetworkSecurityGroupRuleCounter"
  ]
  tags = merge({ "ResourceName" = format("%s", local.resource_names.dinsg_diag_name) }, local.tags)
  depends_on = [
    module.azurerm_nsg_dataingest
  ]
}

# This module helps in creating NSG Flow Logs for "Data Ingest NSG"

resource "azurerm_network_watcher_flow_log" "dataingest" {
  network_watcher_name = "NetworkWatcher_francecentral"
  resource_group_name  = "NetworkWatcherRG"

  network_security_group_id = module.azurerm_nsg_dataingest.network_security_group_id
  storage_account_id        = data.azurerm_storage_account.log.id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.laws.workspace_id
    workspace_region      = var.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.laws.id
    interval_in_minutes   = 10
  }
  depends_on = [
    module.azurerm_nsg_dataingest
  ]

}
# This module helps in creating Route Table in Dataingest subnet in Spoke Environemnt
# This Route Table helps user defined routing and by creating network routes to route the traffic 

module "azurerm_routetable_dataingest" {
  source              = "../resources/Route-Table-module"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  name                = local.resource_names.dataingest_rt_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.dataingest_rt_name) }, local.tags)
  depends_on          = [module.azurerm_snet_dataingest]
}

# This module helps in Routing Rule

module "azurerm_route_approute" {
  source              = "../resources/Route_module"
  name                = "internet"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  route_table_name    = module.azurerm_routetable_dataingest.route_table_name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet" # VirtualAppliance
  depends_on          = [module.azurerm_routetable_dataingest]
}

# This module helps in associating Route Table to Subnet

module "azurerm_dataingest_approutetbl_association" {
  source         = "../resources/Subnet_route_table_association_module"
  subnet_id      = module.azurerm_snet_dataingest.subnet_id
  route_table_id = module.azurerm_routetable_dataingest.route_table_id
  depends_on     = [module.azurerm_snet_dataingest, module.azurerm_routetable_dataingest, module.azurerm_route_approute]
}

###################################################
# App Gateway  resources provisioning
###################################################

# This module creates App Gateway Subnet in spoke Virtual Network for Spoke Environment.
# This subnet host Applicaiton gateway

module "azurerm_snet_appgw" {
  source               = "../resources/SubNet_module"
  resource_group_name  = module.azurerm_rg_spoke.resource_group_name
  name                 = local.resource_names.appgw_snet_name
  subnet_addressSpaces = var.snet_appgw_addressspaces
  virtual_network_name = module.azurerm_vnet_spoke.virtual_network_name
  depends_on           = [module.azurerm_vnet_spoke]
}

# This module helps in creating Application Gateway in Spoke Environment
# This App Gateway helps to manage traffic to web applications

module "azurerm_app_gw" {
  source              = "../resources/Application_gateway_module"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  appgw_name          = local.resource_names.appgw_name
  subnet_id           = module.azurerm_snet_appgw.subnet_id
  private_ip_address  = var.appgw_private_ip_address
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.appgw_name) }, local.tags)
  depends_on          = [module.azurerm_snet_appgw]
}

# This module helps in creating Route Table in Dataingest subnet in Spoke Environemnt
# This Route Table helps user defined routing and by creating network routes to route the traffic 

module "azurerm_routetable_appgw" {
  source              = "../resources/Route-Table-module"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  name                = local.resource_names.appgw_rt_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.appgw_rt_name) }, local.tags)
  depends_on          = [module.azurerm_snet_appgw]
}

# This module helps in Routing Rule

module "azurerm_route_appgwroute" {
  source              = "../resources/Route_module"
  name                = "internet"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  route_table_name    = module.azurerm_routetable_appgw.route_table_name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet" # VirtualAppliance
  depends_on          = [module.azurerm_routetable_appgw]
}

# This module helps in associating Route Table to Subnet

module "azurerm_appgw_approutetbl_association" {
  source         = "../resources/Subnet_route_table_association_module"
  subnet_id      = module.azurerm_snet_appgw.subnet_id
  route_table_id = module.azurerm_routetable_appgw.route_table_id
  depends_on     = [module.azurerm_snet_appgw, module.azurerm_routetable_appgw, module.azurerm_route_appgwroute]
}

# This module helps in creating Network Security Group in spoke Resource Group for App Gateway
# This NSG is required to restrict traffic to App Gateway
# Due to security best practices, All Inbound & OutBound DENY Rules were applied for all NSG's. 
# In Build Phase please implement the required rules that's necessary

module "azurerm_nsg_appgw" {
  source              = "../resources/NetworkSecurityGroup_module"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  name                = local.resource_names.appgw_nsg_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.appgw_nsg_name) }, local.tags)
  depends_on          = [module.azurerm_snet_appgw]
  rules = [
    {
      name                       = "Deny_Inbound"
      priority                   = "200"
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_ranges         = "*"
      destination_port_ranges    = "0-65199"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "All InBound Deny"
    },
    {
      name                       = "Allow_GWM"
      priority                   = "190"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "TCP"
      source_port_ranges         = "*"
      destination_port_ranges    = "65200-65535"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
      description                = "Allow Internet Inbound"
    }
  ]

}

# This module helps in associating Subnet with Network Security Group.
# This NSG and Subnet Association is required to restrict traffic to App Gateway subnet

module "azurerm_nsg_appgw_assoc" {
  source                    = "../resources/Subnet_NSG_association_module"
  subnet_id                 = module.azurerm_snet_appgw.subnet_id
  network_security_group_id = module.azurerm_nsg_appgw.network_security_group_id
  depends_on                = [module.azurerm_snet_appgw, module.azurerm_nsg_appgw]
}

# This module helps in creating Diagnosis settings for "App Gateway NSG"

module "azure_diagnosticsettings_appgwnsg" {
  source              = "../resources/NSG_Diagnostic_Settings"
  diag_name           = local.resource_names.appgwnsg_diag_name
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  destination         = data.azurerm_log_analytics_workspace.laws.id
  target_ids          = [module.azurerm_nsg_appgw.network_security_group_id]
  storage_account_id  = data.azurerm_storage_account.log.id
  logs = [
    "NetworkSecurityGroupEvent",
    "NetworkSecurityGroupRuleCounter"
  ]
  tags = merge({ "ResourceName" = format("%s", local.resource_names.appgwnsg_diag_name) }, local.tags)
  depends_on = [
    module.azurerm_nsg_appgw
  ]
}
# This module helps in creating NSG Flow Logs for "AppGW NSG"

resource "azurerm_network_watcher_flow_log" "appgwnsg" {
  network_watcher_name = "NetworkWatcher_francecentral"
  resource_group_name  = "NetworkWatcherRG"

  network_security_group_id = module.azurerm_nsg_appgw.network_security_group_id
  storage_account_id        = data.azurerm_storage_account.log.id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.laws.workspace_id
    workspace_region      = var.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.laws.id
    interval_in_minutes   = 10
  }
  depends_on = [
    module.azurerm_nsg_appgw
  ]
}

###################################################
# Data Process Resources provisioning
###################################################

# This module creates Subnet in spoke Virtual Network for SPOKE Environment.
# This subnet act as Data Ingest Subnet

module "azurerm_snet_dataprocess" {
  source               = "../resources/SubNet_module"
  resource_group_name  = module.azurerm_rg_spoke.resource_group_name
  name                 = local.resource_names.dataprocess_snet_name
  subnet_addressSpaces = var.snet_dataprocess_addressspaces
  virtual_network_name = module.azurerm_vnet_spoke.virtual_network_name
  depends_on           = [module.azurerm_vnet_spoke]
}

# This module helps in creating Network Security Group in SPOKE Resource Group for dataprocess
# This NSG is required to restrict traffic to dataprocess
# Due to security best practices, All Inbound & OutBound DENY Rules were applied for all NSG's. 
# In Build Phase please implement the required rules that's necessary

module "azurerm_nsg_dataprocess" {
  source              = "../resources/NetworkSecurityGroup_module"
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  name                = local.resource_names.dataprocess_nsg_name
  tags                = merge({ "ResourceName" = format("%s", local.resource_names.dataprocess_nsg_name) }, local.tags)
  depends_on          = [module.azurerm_snet_dataprocess]
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
# This NSG and Subnet Association is required to restrict traffic to dataprocess subnet

module "azurerm_nsg_dataprocess_assoc" {
  source                    = "../resources/Subnet_NSG_association_module"
  subnet_id                 = module.azurerm_snet_dataprocess.subnet_id
  network_security_group_id = module.azurerm_nsg_dataprocess.network_security_group_id
  depends_on                = [module.azurerm_snet_dataprocess, module.azurerm_nsg_dataprocess]
}
# This module helps in creating Diagnosis settings for "DataProcess NSG"

module "azure_diagnosticsettings_dpnsg" {
  source              = "../resources/NSG_Diagnostic_Settings"
  diag_name           = local.resource_names.dpnsg_diag_name
  resource_group_name = module.azurerm_rg_spoke.resource_group_name
  destination         = data.azurerm_log_analytics_workspace.laws.id
  target_ids          = [module.azurerm_nsg_dataprocess.network_security_group_id]
  storage_account_id  = data.azurerm_storage_account.log.id
  logs = [
    "NetworkSecurityGroupEvent",
    "NetworkSecurityGroupRuleCounter"
  ]
  tags = merge({ "ResourceName" = format("%s", local.resource_names.dpnsg_diag_name) }, local.tags)
  depends_on = [
    module.azurerm_nsg_dataprocess
  ]
}

# This module helps in creating NSG Flow Logs for "Dataprocess NSG"

resource "azurerm_network_watcher_flow_log" "dataprocess" {
  network_watcher_name = "NetworkWatcher_francecentral"
  resource_group_name  = "NetworkWatcherRG"

  network_security_group_id = module.azurerm_nsg_dataprocess.network_security_group_id
  storage_account_id        = data.azurerm_storage_account.log.id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.laws.workspace_id
    workspace_region      = var.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.laws.id
    interval_in_minutes   = 10
  }
  depends_on = [
    module.azurerm_nsg_dataprocess
  ]
}
#This module helps in creating Private End Point in Jump Host Subnet.
#This Private End Point helps in private connection to Storage Account

module "azurerm_jumpvm_private_endpoint" {
  source                           = "../resources/Private_Endpoint"
  location                         = var.location
  private_endpoint_name            = local.resource_names.dataprocess_private_endpoint_name
  resource_group_name              = module.azurerm_rg_spoke.resource_group_name
  subnet_id                        = module.azurerm_snet_dataprocess.subnet_id
  private_connection_name          = var.private_connection_name
  private_link_enabled_resource_id = data.azurerm_storage_account.log.id
  subresource_names                = var.subresource_names
  depends_on = [
    module.azurerm_snet_dataprocess,
  ]

}