###################################################
#  Common
###################################################
variable "resource_group" {
  type        = string
  description = "prod Resource Group Name in Azure"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "region" {
  type        = string
  description = "Resources region in Azure"
}


# For RSV_Azure_Backup
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
  description = "The number of yearly backups to keep. Must be between 1 and 9999."
  type        = number

}

variable "file_share_yearly_weekdays" {
  description = "The number of yearly backups to keep. Must be between 1 and 9999."
  type        = list(string)
  default     = []
}

variable "file_share_yearly_weeks" {
  description = "The number of yearly backups to keep. Must be between 1 and 9999."
  type        = list(string)
  default     = []
}
variable "file_share_yearly_months" {
  description = "The number of yearly backups to keep. Must be between 1 and 9999."
  type        = list(string)
  default     = []
}
############################################
#azure monitor
############################################


variable "sku" {
  default = ""
}

variable "monitor_action_group_name" {
  type        = string
  description = "value"
}
variable "webhook-receiver-name" {
  type        = string
  description = "value"
}

variable "webhook-service-uri" {
  type    = string
  default = "value"
}

variable "short_name" {
  type        = string
  description = "value"

}

# sms
variable "sms-receiver-name" {
  type        = string
  description = "value"
}

variable "country-code" {
  type        = string
  description = "value"
}

variable "phone-number" {
  type        = string
  description = "value"
}

#Email
variable "email-reciever-name" {
  type        = string
  description = "value"
}

variable "email-address" {
  type        = string
  description = "value"

}

# storage account name
variable "storage" {
  type        = string
  description = "The name of the storage account in which the resources are created"
  default     = " "
}

variable "monitor_metric_alert" {
  type        = string
  description = "The name of the monitor_metric_alert in which the resources are created"

}
#######################################
# Dns
#######################################
variable "create_zone" {

  default = ""

}

variable "dns_zone_name" {

  type = string

}

variable "tag_dns_zone_name" {

}
/*
###################################################
# administrator AD Group
###################################################
variable "admin_adgroup_name" {
  type        = string
  description = "Name of the The resource group."
  default     = ""
}
variable "admin_adgroup_users" {
  type        = list(string)
  description = "Members of the Group"
  default     = []
}
###################################################
# DevOps AD Group
###################################################
variable "devops_adgroup_name" {
  type        = string
  description = "Name of the The resource group."
  default     = ""
}
variable "devops_adgroup_users" {
  type        = list(string)
  description = "Members of the Group"
  default     = []
}
###################################################
# Reader AD Group
###################################################
variable "reader_adgroup_name" {
  type        = string
  description = "Name of the The resource group."
  default     = ""
}
variable "reader_adgroup_users" {
  type        = list(string)
  description = "Members of the Group"
  default     = []
}
###################################################
# Useraccessadmin AD Group
###################################################
variable "useraccessadmin_adgroup_name" {
  type        = string
  description = "Name of the The resource group."
  default     = ""
}
variable "useraccessadmin_adgroup_users" {
  type        = list(string)
  description = "Members of the Group"
  default     = []
}
###################################################
# Developer AD Group
###################################################
variable "developer_adgroup_name" {
  type        = string
  description = "Name of the The resource group."
  default     = ""
}
variable "developer_adgroup_users" {
  type        = list(string)
  description = "Members of the Group"
  default     = []
}
###################################################
# Devops Approver AD Group
###################################################
variable "devops_approver_adgroup_name" {
  type        = string
  description = "Name of the The resource group."
  default     = ""
}
variable "devops_approver_adgroup_users" {
  type        = list(string)
  description = "Members of the Group"
  default     = []
}
###################################################
# Security AD Group
###################################################
variable "security_adgroup_name" {
  type        = string
  description = "Name of the The resource group."
  default     = ""
}
variable "security_adgroup_users" {
  type        = list(string)
  description = "Members of the Group"
  default     = []
}
*/
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