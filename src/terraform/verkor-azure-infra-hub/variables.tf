variable "resource_group" {
  type        = string
  description = "Transit Resource Group Name in Azure"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "region" {
  type        = string
  description = "Resources region in Azure"
}

variable "vnet_transit_addressspace" {
  type        = list(any)
  description = "Resources region in Azure"
}
variable "service_endpoints" {
  description = "Service endpoints to add to subnet"
  type        = list(string)
  default = [
    "Microsoft.AzureActiveDirectory",
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage"
  ]
}

###################################################
# Firewall Public IP Variables
###################################################
variable "firewall_pip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
  type        = string
}
variable "firewall_pip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic"
  type        = string

}
variable "availability_zone" {
  type        = string
  default     = ""
  description = "The availability zone to allocate the Public IP in. Possible values are Zone-Redundant, 1, 2, 3, and No-Zone. Defaults to Zone-Redundant"

}
###################################################
# Firewall Variables
###################################################
variable "snet_firewall_addressspaces" {
  type = list(any)
}
variable "firewall_subnet_name" {
  type = string
}
variable "firewall_web_rules" {
  description = "List of application rules to apply to firewall."
  type        = list(object({ name = string, action = string, source_addresses = list(string), destination_ports = list(string), destination_addresses = list(string), protocols = list(string), priority = string }))
  default     = []
}
variable "fw-name" {
  type = string
}
variable "threat_intel_mode" {
  description = "The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert,Deny and empty string. Defaults to Alert"
  default     = ""
}


###################################################
# log analytics workspace
###################################################
variable "log_resource_group" {
  type        = string
  description = "Log Resource Group Name in Azure"
}
variable "log_analytics_sku" {
  type        = string
  description = "Sets the Log Analytics workspace SKU. Possible values include: Free, Standard, PerGB2018"
  default     = "PerGB2018"
}
variable "retention_in_days" {
  description = "Days to retain logs in Log Analytics"
  type        = number
  default     = "30"
}

###################################################
# VPN Gateway Variables
###################################################

variable "snet_vpn_gateway_addressspaces" {
  type = list(any)
}

variable "vpn_gateway_pip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
  type        = string
}
variable "vpn_gateway_pip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic"
  type        = string
}

variable "vpn_gateway_sku" {
  description = "The SKU of vpn gateway. The allowed Skus are VpnGw1AZ,VpnGw2AZ,VpnGw3AZ,VpnGw4AZ,VpnGw5AZ,VpnGw1,VpnGw2,VpnGw3,VpnGw4,VpnGw5."
  type        = string
}
variable "vpn_gateway_private_IP_allocation" {
  description = "Defines the allocation method for this Private IP address. Possible values are Static or Dynamic"
  type        = string
  default     = "Dynamic"
}
###################################################
# KeyVault Variables
###################################################
variable "enabled_for_deployment" {
  type        = bool
  description = "Allow Virtual Machines to retrieve certificates stored as secrets from the key vault."
  default     = false
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Allow Disk Encryption to retrieve secrets from the vault and unwrap keys."
  default     = false
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  default     = false
}

variable "purge_protection_enabled" {
  type    = bool
  default = false
}

variable "soft_delete_retention_days" {
  type    = number
  default = 90
}
variable "enabled_for_template_deployment" {
  type        = bool
  description = "Allow Resource Manager to retrieve secrets from the key vault."
  default     = false
}
variable "access_policies" {
  description = "Map of access policies for an object_id (user, service principal, security group) to backend."
  type = list(object({
    object_id               = string,
    certificate_permissions = list(string),
    key_permissions         = list(string),
    secret_permissions      = list(string),
    storage_permissions     = list(string),
  }))
  default = []
}
###################################################
# JumpVM Key Secrets Variables
###################################################

variable "vm1secret_name" {
  type        = string
  description = "JumpHost VM-1 Vault Secret Name in Azure"
}

variable "vm2secret_name" {
  type        = string
  description = "JumpHost VM-2 Vault Secret Name in Azure"
}
###################################################
# Jump Host VM 01 Variables
###################################################

variable "jumpvm_subnet_name" {
  type = string
}
variable "snet_jumpvm_addressspaces" {
  type = list(any)
}
variable "private_ip_address_allocation" {
  type        = string
  description = "Azure vm private ip allocation method"
  default     = "Dynamic"
}
variable "vm_size" {
  type        = string
  description = "vm_size"
  default     = ""
}
variable "i_offer" {
  type        = string
  description = "offer for the vm"
  default     = "WindowsServer"
}
variable "i_publisher" {
  type        = string
  description = "Publisher for the  vm"
  default     = "MicrosoftWindowsServer"
}
variable "i_sku" {
  type        = string
  description = "sku for the vm"
  default     = "2016-Datacenter"
}
variable "i_version" {
  type        = string
  description = "version for the vm"
  default     = "latest"
}
variable "caching" {
  type        = string
  description = "Catching type as like ReadWrite"
  default     = "ReadWrite"
}
variable "create_option" {
  type        = string
  description = "Create option as like FromImage"
  default     = "FromImage"
}
variable "managed_disk_type" {
  type        = string
  description = "managed disk type"
  default     = "Standard_LRS"
}

variable "jumpvm1_ip_config_name" {
  type    = string
  default = ""
}
variable "jumpvm1_os_disk_name" {
  type        = string
  description = "os_disk"
  default     = ""
}
variable "vm1_computer_name" {
  type        = string
  description = "Name of the Jump Host VM 01"
}
variable "vm1_admin_username" {
  type        = string
  description = "User Name of the Jump Host VM 01"
}

###################################################
# Jump Host VM 02 Variables
###################################################
variable "jumpvm2_ip_config_name" {
  type    = string
  default = ""
}
variable "jumpvm2_os_disk_name" {
  type        = string
  description = "os_disk"
  default     = ""
}
variable "vm2_computer_name" {
  type        = string
  description = "Name of the Jump Host VM 02"
}
variable "vm2_admin_username" {
  type        = string
  description = "User Name of the Jump Host VM 02"
}

variable "private_connection_name" {
  type        = string
  description = "Connection Name in Azure"
}

variable "subresource_names" {
  default = ["blob"]

}
###################################################
# TAGs
###################################################
variable "customer" {
  type = string
}
variable "category" {
  type = string
}
variable "environment" {
  type = string
}
variable "environment_short" {
  type = string
}
variable "business_unit" {
  type = string
}
variable "applicationname" {
  type = string
}
variable "applicationname_short" {
  type = string
}
variable "approver_name" {
  type = string
}
variable "owner_name" {
  type = string
}
variable "data_classification" {
  type = string
}
variable "contact" {
  type = string
}