variable "resource_group_name" {
  description = "Name of the resource group where the storage account belongs"
}

variable "location" {
  description = "Azure region where the storage account will be located"
}

variable "virtual_network_name" {
  description = "Name of virtual network"
}

variable "vm_sql_name" {
  description = "Name of virtual network"
}
variable "sql_vm_nic_ip" {
  description = "Azure vm vm private ip allocation method"

}
###################

//The following section creates a VM and attaches the virtual NIC to it.

variable "sqlvmextension_name" {
  description = "sqlvmname"
  default     = ""
}
variable "vm_size" {
  description = "vm_size"
  default     = ""
}

//Find the VM images in the Azure Marketplace with the Azure CLI tool
variable "i_offer" {
  description = "offer for the vm"
  default     = "SQL2019-WS2019"
}
variable "i_publisher" {
  description = "Publisher for the  vm"
  default     = "MicrosoftSQLServer"
}

variable "i_sku" {
  description = "sku for the vm"
  default     = "Enterprise"
}
variable "i_version" {
  description = "version for the vm"
  default     = "latest"
}

//boot diagnosetic: 
variable "boot_url" {
  description = "boot_url"
  default     = "https://sfssqlvm.blob.core.windows.net"
}

//Windows OS disk by default it is of 128 GB
variable "os_disk" {
  description = "os_disk"
  default     = "sqlnewOsDisk"
}
// Adding additional disk for persistent storage
variable "add_disk_name" {
  description = "additional_disk"
  default     = "sqlvm_disk_1"
}
variable "add_disk_size" {
  description = "disk size in GB"
  default     = "1000"
}

//Here defined admin uid/pwd and also comupter name
variable "computer_name" {
  description = "name"
  default     = "sfstestsqlvm"
}

variable "admin_username" {
  description = "name"
  default     = ""
}

variable "admin_password" {
  description = "passwd"
  default     = ""
}
#  Tags
variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}
# sql disks
variable "sqldisk1_name" {
  default = "secondarydiskfortsqlvm"
}
variable "sqldisk2_name" {
  default = "sqlvm_disk_3"
}
variable "sqldisk3_name" {
  default = "sqlvm_disk_4"
}
variable "sql_rg" {
  default = "rg-eu2-siesmart-spoke-t-app"
}
