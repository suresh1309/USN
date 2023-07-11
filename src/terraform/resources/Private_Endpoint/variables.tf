variable "resource_group_name" {
  type = string
}

variable "private_endpoint_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_connection_name" {
  type = string
}

variable "private_link_enabled_resource_id" {
  type = string
}

variable "subresource_names" {
  type = list(string)
}

variable "zone" {
  type        = string
  description = "Enter abbreviation for Zone. e=External, i=Internal, m=Management"
  default     = "i"
}
variable "environment" {
  type        = string
  description = "The environment denotation.d=Development, t=Test, a=Acceptance, p=Production, dt=Dev-Test, ap=Acceptance-Production"
  default     = "d"
}