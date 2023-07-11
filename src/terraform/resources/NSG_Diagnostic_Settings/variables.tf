variable "diag_name" {
  description = "Name of Diagnostic settings"
  type        = string
  default     = ""
}
variable "resource_group_name" {
  description = "Name of the resource group where the storage account belongs"
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
variable "destination" {
  description = "Destination for events, either Event Hub, Log Analytics or a Storage account"
  type        = string
  default     = ""
}
variable "storage_account_id" {
  description = "stroage account has been created "
  type        = string
  default     = ""
}
variable "target_ids" {
  description = "List of resource ids to create diagnostic settings for."
  type        = list(string)
}
variable "eventhub_name" {
  description = "Event Hub name if destination is an event hub."
  type        = string
  default     = ""
}
variable "logs" {
  description = "List of log categories to log."
  type        = list(string)
  default     = ["AuditEvent"]
}

variable "retention_days" {
  description = "about_retention_days"
  type        = number
  default     = 30
}
variable "retention_policy_log_enable" {
  description = "This is about retention policy for logs"
  type        = bool
  default     = true
}
