variable "name" {
  type        = string
  description = "Name of the Network Security Group."
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group where the storage account lives. When no NSG name is given than the resource group name must be in the Sogeti naming format."
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}

variable "rules" {
  type    = list(map(string))
  default = []
}
