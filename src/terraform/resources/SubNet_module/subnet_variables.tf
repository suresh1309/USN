variable "name" {
  type        = string
  description = "Name of the Subnet"
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group. When no subnet name is given than the resource group name must be in the Sogeti naming format."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of an existing Virtual Network."
}

variable "subnet_addressSpaces" {
  type    = list(any)
  default = ["10.1.0.0/24"]
}

variable "service_endpoints" {
  type    = list(any)
  default = ["Microsoft.AzureActiveDirectory", "Microsoft.ContainerRegistry", "Microsoft.KeyVault", "Microsoft.Storage"]
}