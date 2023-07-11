variable "name" {
  type    = string
  default = ""
}
variable "applicationname" {
  default     = ""
  type        = string
  description = "Name of the application"
}
variable "environment" {
  default     = ""
  type        = string
  description = "Name of the environment"
}
variable "resource_group_name" {
  description = "Name of the resource group in which the VNet Gateway will be created"
  type        = string
  default     = ""
}
variable "azurerm_public_ip" {
  type    = string
  default = ""
}
variable "azurerm_subnet" {
  type    = string
  default = ""
}
# To understand how public IPs are allocated, see https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-ip-addresses-overview-arm
variable "type" {
  description = "Type of VNet Gateway -- Vpn or ExpressRoute"
  type        = string
  default     = "Vpn"
}
variable "vpn_type" {
  description = "Routing type for VNet Gateway -- RouteBased or PolicyBased"
  type        = string
  default     = "RouteBased"
}
variable "enable_bgp" {
  description = "Enable Border Gateway Protocol for VNet Gateway"
  type        = bool
  default     = false
}
variable "active_active" {
  description = "Enable Active-Active VPN configuration"
  type        = bool
  default     = false
}
# For available SKUs, see https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways#gwsku
variable "sku" {
  description = "Size and capacity of VNet Gateway"
  type        = string
  default     = "VpnGw1"
}
variable "private_ip_allocation" {
  description = "Define how the private IP address of the VNet Gateway is allocated -- Static or Dynamic"
  type        = string
  default     = ""
}
variable "tags" {
  description = "Map of tags to add to VNet Gateway and associated resources"
  type        = map(any)
  default     = {}
}