##########################################################
# Common
##########################################################
resource_group = "shared"
location       = "France Central"
region         = "frc"

#############################################################################
####        #RSV_Azure_Backup          ####
#############################################################################
recovery_vault_name = "rsv-app-vrk-usn-frc"
recovery_vault_sku  = "Standard"
create_rsvault      = "vrk-rsv"

#############################################################################
####        Fileshare backup policy          ####
#############################################################################

policy_file_share    = "fileshare-frc-usn-s-rsv"
file_share_timezone  = "UTC"
file_share_time      = "22:30"
file_share_retention = 60
file_share_weekly    = 7
file_share_monthly   = 7
file_share_yearly    = 7

file_share_weekly_weekdays  = ["Sunday", "Wednesday", "Friday", "Saturday"]
file_share_monthly_weekdays = ["Sunday", "Wednesday"]
file_share_monthly_weeks    = ["First", "Last"]
file_share_yearly_weekdays  = ["Sunday"]
file_share_yearly_weeks     = ["Last"]
file_share_yearly_months    = ["January"]
########################################################
# Azure monitor
########################################################

sku                       = "Standard"
monitor_action_group_name = "monitoraction16"
webhook-receiver-name     = "monitorreceivername"
webhook-service-uri       = "http://example.com/alert"
short_name                = "agsmsalert"
sms-receiver-name         = "naresh"
country_code              = "1"
phone_number = "1231231234"

email-reciever-name       = "naresh"
email-address             = "nareshsuresh.azure@gmail.com"
monitor_metric_alert      = "metricalert-01"

##########################################
#DNS
##########################################
dns_zone_name     = "btg.com"
create_zone       = "true"
tag_dns_zone_name = "btg"
/*
###################################################
# AD Groups & Members
###################################################
admin_adgroup_name = "verkor-owners"
admin_adgroup_users = [
  "adrien.richard@verkor.com",
  "julien.darvey@verkor.com"
]

devops_adgroup_name = "verkor-devOps"
devops_adgroup_users = [
  "adrien.richard@verkor.com",
  "julien.darvey@verkor.com"
]


reader_adgroup_name = "verkor-readers"
reader_adgroup_users = [
  "adrien.richard@verkor.com",
  "julien.darvey@verkor.com"
]

useraccessadmin_adgroup_name = "verkor-useraccessadmins"
useraccessadmin_adgroup_users = [
  "adrien.richard@verkor.com",
  "julien.darvey@verkor.com"
]

developer_adgroup_name = "verkor-developers"
developer_adgroup_users = [
  "adrien.richard@verkor.com",
  "julien.darvey@verkor.com"
]

devops_approver_adgroup_name = "verkor-devOps-Approves"
devops_approver_adgroup_users = [
  "adrien.richard@verkor.com",
  "julien.darvey@verkor.com"
]

security_adgroup_name = "verkor-security"
security_adgroup_users = [
  "adrien.richard@verkor.com",
  "julien.darvey@verkor.com"
]
*/

##########################################################
# TAGs
##########################################################
customer              = "Verkor"
category              = "platform" #platform, core, app
business_unit         = "Verkor"
applicationname       = "Manufacturing Data Platform"
applicationname_short = "vrk"
data_classification   = "Confidential"
approver_name         = "nareshsuresh.azure@gmail.com"
environment           = "shared"
environment_short     = "services"
owner_name            = "naresh"
contact               = "nareshsuresh.azure@gmail.com"