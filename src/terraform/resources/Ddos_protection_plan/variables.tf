variable "name" {
  type        = string
  description = "name of the DDOS protection Plan"
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group. When no ddos name is given than the resource group name must be in the Sogeti naming format."

}

variable "location" {
  type        = string
  description = "The location name of the The resource group."
  default     = ""
}

variable "applicationname" {
  type        = string
  description = "The application name of the The resource group."
  default     = ""
}

variable "environment" {
  type        = string
  description = "The environment of the system in the resource group, can be t(team - the environment the team can use) d(development), t(test), a(acceptance), p(production) or any other the team usess."
  default     = ""
}

variable "tags" {
  type        = map(any)
  description = "A list of tags to be applied"
  default     = {}
}
