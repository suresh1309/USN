variable "location" {
  type        = string
  description = "Resources location in Azure"
  default     = "France Central"
}
variable "region" {
  type        = string
  description = "Resources region in Azure"
  default     = "fc"
}
/*
###################################################
# TAGs
###################################################
variable "customer" {
  type = string
}
variable "environment" {
  type = string
}
variable "environment_short" {
  type = string
}*/
variable "business_unit" {
  type    = string
  default = "vrk"
}
/*
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
*/