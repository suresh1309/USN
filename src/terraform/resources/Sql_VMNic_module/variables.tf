variable "resource_group_name" {

}

variable "location" {

}

variable "virtual_network_name" {

}

variable "vm_vmnic_SQL" {

}


variable "environment" {

}

variable "subnet_data_id" {

}

variable "private_ip_address_allocation" {
  description = "Azure vm vm private ip allocation method"
  default     = "Dynamic"
}

variable "region" {

}
variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}

