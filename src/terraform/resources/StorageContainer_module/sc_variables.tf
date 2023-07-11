variable "name" {
  type        = string
  description = "Name of the storage container"
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group where the storage account lives. When no storage account name is given than the resource group name must be in the Sogeti naming format."
}

variable "storageaccountname" {
  type        = string
  description = "(Optional)The name of the storage account."
  default     = ""
}

variable "index" {
  type        = string
  description = "When more as one storage acccount is used in a resource group this index number can be used."
  default     = ""
}
