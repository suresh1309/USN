variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "route_table_name" {
  type = string
}

variable "address_prefix" {
  type = string
}

variable "next_hop_type" {
  type        = string
  description = "The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None"
  default     = "None"
}

variable "next_hop_in_ip_address" {
  type        = string
  description = "Contains the IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance."
  default     = null
}