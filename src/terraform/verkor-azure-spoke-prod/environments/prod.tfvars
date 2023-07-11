##########################################################
# Common
##########################################################
resource_group          = "prod"
location                = "France Central"
region                  = "frc"
vnet_spoke_addressspace = ["10.205.13.0/24"]
private_connection_name = "pc-dataproc-logst-prod"
##########################################################
# Subnets Address Space
##########################################################
snet_front_addressspaces       = ["10.205.13.64/26"]
snet_dataingest_addressspaces  = ["10.205.13.0/27"]
snet_appgw_addressspaces       = ["10.205.13.32/27"]
snet_dataprocess_addressspaces = ["10.205.13.128/26"]

###################################################
# App Gateway
###################################################

appgw_private_ip_address = "10.205.13.38"

##########################################################
# TAGs
##########################################################
customer              = "Verkor"
category              = "app" #platform, core, app
business_unit         = "Verkor"
applicationname       = "Manufacturing Data Platform"
applicationname_short = "vrk"
data_classification   = "Confidential"
approver_name         = "julien.darvey@verkor.com,adrien.richard@verkor.com"
environment           = "prod"
environment_short     = "prod"
owner_name            = "Julien Darvey, Adrien Richard"
contact               = "julien.darvey@verkor.com,adrien.richard@verkor.com"
