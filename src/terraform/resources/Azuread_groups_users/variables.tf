variable "adgroup_name" {
  type        = string
  description = "Name of the The resource group."
  default     = ""
}

variable "group_members" {
  type        = list(string)
  description = "Members of the Group"
  default     = []
}