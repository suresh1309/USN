variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the DNS zone where the records will be added."
}

variable "dns_zone_name" {
  type        = string
  description = "The name of the DNS zone within the given resource group where the records will be added."
}

variable "location" {
  type        = string
  description = ""
}

variable "region" {
  type        = string
  description = ""
}

variable "create_zone" {
  type        = string
  description = ""
  default     = "true"
}

variable "tag_dns_zone_name" {
  type        = string
  description = ""
}

# variable "tags" {
#   type = string
#   description = "(optional) describe your variable"
# }