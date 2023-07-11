###################################################
#  Common
###################################################
variable "resource_group" {
  type        = string
  description = "SPOKE Resource Group Name in Azure"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "region" {
  type        = string
  description = "Resources region in Azure"
}
variable "vnet_spoke_addressspace" {
  type        = list(any)
  description = "Resources region in Azure"
}

variable "service_endpoints" {
  description = "Service endpoints to add to subnet"
  type        = list(string)
  default = [
    "Microsoft.AzureActiveDirectory",
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage"
  ]
}
variable "snet_front_addressspaces" {
  type        = list(any)
  description = "Resources region in Azure"
}

variable "snet_dataingest_addressspaces" {
  type        = list(any)
  description = "Resources region in Azure"
}

variable "snet_appgw_addressspaces" {
  type        = list(any)
  description = "Resources region in Azure"
}
variable "appgw_private_ip_address" {
  type = string
}
variable "snet_dataprocess_addressspaces" {
  type        = list(any)
  description = "Resources region in Azure"
}
variable "private_connection_name" {
  type        = string
  description = "Connection Name in Azure"
}
variable "subresource_names" {
  default = ["blob"]
}
###################################################
# TAGs
###################################################
variable "customer" {
  type = string
}
variable "category" {
  type = string
}
variable "environment" {
  type = string
}
variable "environment_short" {
  type = string
}
variable "business_unit" {
  type = string
}
variable "applicationname" {
  type = string
}
variable "applicationname_short" {
  type = string
}
variable "approver_name" {
  type = string
}
variable "owner_name" {
  type = string
}
variable "data_classification" {
  type = string
}
variable "contact" {
  type = string
}