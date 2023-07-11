variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the storage account belongs"
  default     = ""
}
variable "nic_name" {
  type        = string
  description = "Name of virtual network"
  default     = ""
}
variable "vm_name" {
  type        = string
  description = "Name of virtual network"
  default     = ""
}
variable "subnet_id" {
  type        = string
  description = "The Subnet id of Subnet Already Created"
}
variable "ip_config_name" {
  type        = string
  description = "Name of the Network Interface"
  default     = ""
}
variable "private_ip_address_allocation" {
  type        = string
  description = "Azure vm vm private ip allocation method"
  default     = "Dynamic"
}
# variable "public_ip_address_id" {
#   type        = string
#   description = "Ip Address for Virtual Machine"
# }
variable "vm_size" {
  type        = string
  description = "vm_size"
  default     = "Standard_D4_v3"
}
variable "i_offer" {
  type        = string
  description = "offer for the vm"
  default     = "WindowsServer"
}
variable "i_publisher" {
  type        = string
  description = "Publisher for the  vm"
  default     = "MicrosoftWindowsServer"
}
variable "i_sku" {
  type        = string
  description = "sku for the vm"
  default     = "2016-Datacenter"
}
variable "i_version" {
  type        = string
  description = "version for the vm"
  default     = "latest"
}
variable "os_disk_name" {
  type        = string
  description = "os_disk"
  default     = ""
}
variable "caching" {
  type        = string
  description = "Catching type as like ReadWrite"
  default     = "ReadWrite"
}
variable "create_option" {
  type        = string
  description = "Create option as like FromImage"
  default     = "FromImage"
}
variable "managed_disk_type" {
  type        = string
  description = "managed disk type"
  default     = "Standard_LRS"
}
variable "computer_name" {
  type        = string
  description = "name"
  default     = ""
}
variable "admin_username" {
  type        = string
  description = "name"
}
variable "admin_password" {
  type        = string
  description = "password"
}
variable "create_lmsvm" {
  type        = bool
  description = "lmsvm name"
  default     = true
}
variable "provision_vm_agent" {
  type        = bool
  description = "provision vm agent as true or false"
  default     = true
}
variable "tags" {
  type        = map(any)
  description = "A list of tags to be applied"
  default     = {}
}
variable "applicationname" {
  type        = string
  description = "Name of the application"
  default     = ""
}
variable "environment" {
  type        = string
  description = "Name of the environment"
  default     = ""
}



#Extras
# variable "monitor_vm_nic_ip" {
#   type        = string
#   description = "Azure vm vm private ip allocation method"
#   default     = ""
# }
# variable "cr_option" {
#   type        = string
#   description = "Create option as like FromImage or Empty"
#   default     = "Empty"
# }
# variable "lun" {
#   type        = number
#   description = "lun"
#   default     = "0"
# }

# variable "add_disk_name" {
#   type        = string
#   description = "additional_disk"
#   default     = ""
# }
# variable "add_disk_size" {
#   type        = string
#   description = "disk size in GB"
#   default     = "128"
# }