variable "sa_name" {
  type        = string
  description = "(Optional)The name of the storage account. When the variable name is left empty, than the storage account name must be in the Sogeti naming format."
  default     = ""
}
variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group for the storage account. When the variable name is left empty, than the resource group name must be in the Sogeti naming format."
  default     = ""
}
variable "index" {
  type        = string
  description = "When more as one storage acccount is needed in a resource group this index number can be used."
  default     = ""
}
variable "storage_account_tier" {
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard* and Premium. Changing this forces a new resource to be created"
  default     = "Standard"
}
variable "storage_account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS*, GRS, RAGRS and ZRS."
  default     = "LRS"
}
variable "min_tls_version" {
  description = "(optional) describe your variable"
  default     = "TLS1_2"
}
variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}
