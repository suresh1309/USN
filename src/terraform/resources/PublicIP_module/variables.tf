variable "name" {
  description = "(Required) Specifies the name of the Public IP resource . Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the public ip."
  type        = string
  default     = ""
}

variable "environment" {
  type        = string
  description = "The environment denotation.d=Development, t=Test, a=Acceptance, p=Production, dt=Dev-Test, ap=Acceptance-Production"
  default     = "d"
}

variable "zone" {
  type        = string
  description = "Enter abbreviation for Zone. e=External, i=Internal, m=Management"
  default     = "i"
}

variable "sku" {
  description = "(Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
  type        = string
  default     = "Basic"
}

variable "allocation_method" {
  description = "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  type        = string
  default     = "Static"
}
variable "availability_zone" {
  description = "The availability zone to allocate the Public IP in. Possible values are Zone-Redundant, 1, 2, 3, and No-Zone. Defaults to Zone-Redundant"
  type        = string
  default     = "Zone-Redundant"
}
variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}
