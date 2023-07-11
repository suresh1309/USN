variable "name" {
  type        = string
  description = "(optional) The name of the Key Vault. When the variable name is left empty, than the resource group name must be in the Sogeti naming format."
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group for the Key Vault.  When the variable name is left empty, than the resource group name must be in the Sogeti naming format."
}

variable "sku" {
  type        = string
  description = "The name of the SKU used for the Key Vault. The options are: `standard`, `premium`."
  default     = "standard"
}

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
  default = 7
}
variable "enabled_for_template_deployment" {
  type        = bool
  description = "Allow Resource Manager to retrieve secrets from the key vault."
  default     = false
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}

variable "default_action" {
  type    = string
  default = "Deny"
}

variable "ip_rules" {
  type    = list(string)
  default = []
}

variable "virtual_network_subnet_ids" {
  type    = list(string)
  default = []
}

