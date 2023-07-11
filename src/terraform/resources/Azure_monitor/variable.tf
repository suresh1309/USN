
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the resources are created"
}

variable "location" {
  type        = string
  description = "The location where resources are created"
}

variable "tags" {
  type = map(any)
  default = {
    Environment = "Devlopment"
  }
}

variable "scopes" {
  type = any
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
}

variable "monitor_metric_alert" {
  type        = string
  description = "The name of the monitor_metric_alert in which the resources are created"

}

