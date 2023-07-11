variable "location" {
  description = "Azure region where the storage account will be located"
}
variable "region" {
  description = "Azure region where the storage account will be located"
}

variable "resource_group_name" {
  description = "Name of the resource group where the storage account belongs"
}

variable "env" {

}

variable "front-door-object" {
  description = "Name of the resource group where the storage account belongs"
}

variable "front-door-waf-object" {
  description = "(Required) AFD Settings of the Azure  Front Door to be created"
}

