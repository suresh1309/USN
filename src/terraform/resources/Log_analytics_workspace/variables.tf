variable "law_name" {
  description = "Name of log analytics workspace"
  type        = string
}
variable "resource_group_name" {
  description = "Name of the resource group where the log analytics workspace belongs"
  type        = string
}
variable "zone" {
  type        = string
  description = "Enter abbreviation for Zone. e=External, i=Internal, m=Management"
  default     = "i"
}
variable "environment" {
  type        = string
  description = "The environment of the system in the resource group, can be t(team - the environment the team can use) d(development), t(test), a(acceptance), p(production) or any other the team usess."
  default     = "d"
}
variable "tags" {
  type        = map(any)
  description = "A list of tags to be applied"
  default     = {}
}
variable "log_analytics_sku" {
  type        = string
  description = "Sets the Log Analytics workspace SKU. Possible values include: Free, Standard, PerGB2018"
  default     = "PerGB2018"
}
variable "retention_in_days" {
  description = "Days to retain logs in Log Analytics"
  type        = number
  default     = "30"
}
