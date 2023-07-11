variable "resource_group_name" {
  type        = string
  description = "Resource Group the resources will belong to"
}

variable "location" {
  type        = string
  description = "Azure location."
}

variable "tags" {
  type = map(any)
  default = {
    Environment = "Devlopment"
  }
}

variable "recovery_vault_name" {
  type        = string
  default     = ""
  description = "Azure Recovery Vault custom name. Empty by default, using naming convention."
}

variable "recovery_vault_sku" {
  type        = string
  default     = "Standard"
  description = "Azure Recovery Vault SKU. Possible values include: `Standard`, `RS0`. Default to `Standard`."
}

variable "create_rsvault" {
  type = string
}

variable "environment" {
  default = ""
}

variable "region" {
  type = string
}


#backup_policy_file_share
variable "policy_file_share" {
  type        = string
  description = "Create policy_file_share"
}

variable "file_share_timezone" {
  description = "Specifies the timezone for schedules. Defaults to `UTC`."
  type        = string
}

variable "file_share_time" {
  description = "The time of day to preform the backup in 24hour format."
  type        = string
}

variable "file_share_retention" {
  description = "The number of daily backups to keep. Must be between 1 and 9999."
  type        = number

}

variable "file_share_weekly" {
  description = "The number of daily backups to keep. Must be between 1 and 9999."
  type        = number

}

variable "file_share_weekly_weekdays" {
  type        = list(string)
  default     = []
  description = "adding vm backup weekdays"
}
variable "file_share_monthly" {
  description = "The number of monthly backups to keep. Must be between 1 and 9999."
  type        = number

}

variable "file_share_monthly_weekdays" {
  type        = list(string)
  default     = []
  description = "adding vm backup monthly weekdays"
}

variable "file_share_monthly_weeks" {
  type        = list(string)
  default     = []
  description = "adding vm backup monthly weekdays"
}
variable "file_share_yearly" {
  type        = number
  description = "The number of yearly backups to keep. Must be between 1 and 9999."
}

variable "file_share_yearly_weekdays" {
  type        = list(string)
  default     = []
  description = "The number of yearlyweekdays backups to keep. Must be between 1 and 9999."
}

variable "file_share_yearly_weeks" {
  type        = list(string)
  default     = []
  description = "The number of yearly weeks backups to keep. Must be between 1 and 9999."
}

variable "file_share_yearly_months" {
  type        = list(string)
  default     = []
  description = "The number of file_share_yearly_months backups to keep. Must be between 1 and 9999."
}
