variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "vnet_address_prefix" {
  type    = list(any)
  default = ["10.1.0.0/24"]
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}