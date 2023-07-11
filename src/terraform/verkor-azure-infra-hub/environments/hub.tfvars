##########################################################
# Common
##########################################################
resource_group            = "transit"
log_resource_group        = "log"
location                  = "France Central"
region                    = "frc"
vnet_transit_addressspace = ["10.205.10.0/24"]
private_connection_name   = "pc-jumpvmsubner-storageaccount"
##########################################################
# Firewall
##########################################################
snet_firewall_addressspaces    = ["10.205.10.64/26"]
firewall_subnet_name           = "AzureFirewallSubnet"
firewall_pip_sku               = "Standard"
firewall_pip_allocation_method = "Static"
fw-name                        = "firewall"
threat_intel_mode              = "Deny"
###################################################
# VPN Gateway
###################################################
snet_vpn_gateway_addressspaces    = ["10.205.10.0/27"]
vpn_gateway_pip_sku               = "Standard"
vpn_gateway_pip_allocation_method = "Static"
vpn_gateway_sku                   = "VpnGw1AZ"
###################################################
# Jump Host VM 01
###################################################
jumpvm_subnet_name        = "JumpVmSubnet"
snet_jumpvm_addressspaces = ["10.205.10.32/27"]
vm_size                   = "Standard_D4_v3"
jumpvm1_ip_config_name    = "Jumpvm1ipconfig"
jumpvm1_os_disk_name      = "jumpvm01osdisk"
vm1_computer_name         = "Jump-Host-vm-01"
vm1_admin_username        = "verkor-admin"
vm1secret_name            = "Jump-Host-vm-01"

###################################################
# Jump Host VM 02
###################################################
jumpvm2_ip_config_name = "Jumpvm2ipconfig"
jumpvm2_os_disk_name   = "jumpvm02osdisk"
vm2_computer_name      = "Jump-Host-vm-02"
vm2_admin_username     = "verkor-admin"
vm2secret_name         = "Jump-Host-vm-02"
access_policies = [

  {
    object_id               = "953a0020-cd60-4d1f-b911-20701e9d01d7" # Adrien Richard Object ID for Key Vault keys and secrets Access
    certificate_permissions = ["create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "setissuers", "update", "backup", "restore"]
    key_permissions         = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
    secret_permissions      = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
    storage_permissions     = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
  },

  {
    object_id               = "1df95569-4e79-4bb6-abba-fd840b5f4e9f" # Julien Darvey Object ID for Key Vault keys and secrets Access
    certificate_permissions = ["create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "setissuers", "update", "backup", "restore"]
    key_permissions         = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
    secret_permissions      = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
    storage_permissions     = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
  },

  {
    object_id               = "f8f9d950-1537-4430-94dc-921f82a4c651" # Veerendra Object ID for temporary access
    certificate_permissions = ["get", "getissuers", "list", "listissuers"]
    key_permissions         = ["get", "list"]
    secret_permissions      = ["get", "list"]
    storage_permissions     = ["get", "getsas", "list", "listsas"]
  }
]
##########################################################
# TAGs
##########################################################
customer              = "Verkor"
category              = "core" #platform, core, app
business_unit         = "Verkor"
applicationname       = "Manufacturing Data Platform"
applicationname_short = "vrk"
data_classification   = "Confidential"
approver_name         = "julien.darvey@verkor.com,adrien.richard@verkor.com"
environment           = "hub"
environment_short     = "hub"
owner_name            = "Julien Darvey, Adrien Richard"
contact               = "julien.darvey@verkor.com,adrien.richard@verkor.com"