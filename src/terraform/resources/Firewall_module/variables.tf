variable "resource_group_name" {
  type        = string
  description = "Name of resource group where firewall will be created"
}

variable "location" {
  type        = string
  default     = "France Central"
  description = "(Optional) The name of the the resource group location."
}
variable "environment" {
  type        = string
  description = "The environment denotation.d=Development, t=Test, a=Acceptance, p=Production, dt=Dev-Test, ap=Acceptance-Production"
  default     = "d"
}

variable "zone" {
  type        = string
  description = "Enter abbreviation for Zone. e=External, i=Internal, m=Management"
  default     = "i"
}
variable "firewall_name" {
  type        = string
  description = "firewall name"
}

variable "virtual_network_name" {
  type        = string
  description = "virtual network name"
}

variable "subnet_firewall_id" {
  type        = string
  description = "firewall sub net"
}

variable "firewall_public_ip_id" {
  type        = string
  description = "firewall sub net"
}

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}

variable "sku_tier" {
  description = "Sku tier of the Firewall. Possible values are Premium and Standard"
  default     = "Standard"
}

variable "sku_name" {
  description = "Sku name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet"
  default     = "AZFW_VNet"
}

variable "threat_intel_mode" {
  description = "The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert,Deny and empty string. Defaults to Alert"
  default     = ""
}

variable "dns_servers" {
  description = "A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution."
  type        = list(string)
  default     = null
}
#Firewall Rules

#Below rules for resolving dns queries using google,  accessing websites, sending mail
variable "firewall_web_rules" {
  description = "List of application rules to apply to firewall."
  type        = list(object({ name = string, action = string, source_addresses = list(string), destination_ports = list(string), destination_addresses = list(string), protocols = list(string), priority = string }))
  default = [
    { name                  = "DNS",
      action                = "Allow",
      source_addresses      = ["10.0.0.0/16"],
      destination_ports     = ["53"],
      destination_addresses = ["8.8.8.8", "8.8.4.4"],
      protocols             = ["TCP", "UDP"],
      priority              = 100
    },
    { name                  = "http",
      action                = "Allow",
      source_addresses      = ["10.0.0.0/16"],
      destination_ports     = ["80"],
      destination_addresses = ["*"],
      protocols             = ["TCP"],
      priority              = 101
    },
    { name                  = "https",
      action                = "Allow",
      source_addresses      = ["10.0.0.0/16"],
      destination_ports     = ["443"],
      destination_addresses = ["*"],
      protocols             = ["TCP"],
      priority              = 102
    },
    { name                  = "smtp",
      action                = "Allow",
      source_addresses      = ["10.0.0.0/16"],
      destination_ports     = ["25"],
      destination_addresses = ["*"],
      protocols             = ["TCP"],
      priority              = 103
    },
    { name                  = "smtps",
      action                = "Allow",
      source_addresses      = ["10.0.0.0/16"],
      destination_ports     = ["587"],
      destination_addresses = ["*"],
      protocols             = ["TCP"],
      priority              = 104
    }
  ]
}
