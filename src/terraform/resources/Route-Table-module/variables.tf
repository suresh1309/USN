variable "resource_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "disable_bgp_route_propagation" {
  type    = bool
  default = false
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}