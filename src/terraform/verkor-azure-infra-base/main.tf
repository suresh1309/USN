#Terraform Statefile

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-vrk-hub-frc"
    storage_account_name = "sttfbackendvrkhubfrc"
    container_name       = "basetfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}


#                       ---------------------------------------------------------
#                                       Terraform resource provisioning
#                       ---------------------------------------------------------

#####################################################################
# Management Group Creation in Hierarchy resource provisioning
#####################################################################

data "azurerm_subscription" "current" {}

data "azurerm_management_group" "root" {
  display_name = "mg-vrk-root"
}

# This module creates Platform Mangement Group & Landingzone Management Group under Root Mangement Group
# It helps to control and manage access, compliance, and policies for subscription within their tenant.

module "management_group_root_children" {
  source               = "../resources/Management_Group_module"
  parent_management_id = data.azurerm_management_group.root.id
  names                = [lower("mg-${var.business_unit}-platform"), lower("mg-${var.business_unit}-landingzones")]
}

#This module creates Children Management Groups (Shared and Connectivity) under Platform Management Group

module "management_group_platform_children" {
  source               = "../resources/Management_Group_module"
  parent_management_id = module.management_group_root_children.management_group_id[0]
  names                = [lower("mg-${var.business_unit}-shared"), lower("mg-${var.business_unit}-connectivity")]
}

#This module creates CORP Children Management Groups under Landing Zone Management Group

module "management_group_landingzone_children" {
  source               = "../resources/Management_Group_module"
  parent_management_id = module.management_group_root_children.management_group_id[1]
  names                = [lower("mg-${var.business_unit}-corp")]
}

#####################################################################
# Management Group Subscription Association resource provisioning
#####################################################################


#This module creates Subscription association with Management Groups 

module "management_subscription_association" {
  source = "../resources/Management_Group_Subscription_Association_module"
  association = {

    "vrk-shared-association" = {
      management_id   = module.management_group_platform_children.management_group_id[0]
      subscription_id = "/subscriptions/2ce4f129-13f1-470b-8877-72f615897ca2" //vrk-lz-shared-001
    },

    "vrk-hub-association" = {
      management_id   = module.management_group_platform_children.management_group_id[1]
      subscription_id = "/subscriptions/11d876fb-4bde-49aa-a1b9-17c136459a45" //vrk-lz-hub-001
    },

    "vrk-nonprod-association" = {
      management_id   = module.management_group_landingzone_children.management_group_id[0]
      subscription_id = "/subscriptions/10f85a55-9ccf-4dcf-89f4-e9121e2df2ec" //vrk-lz-dev-001
    },

    "vrk-qa-association" = {
      management_id   = module.management_group_landingzone_children.management_group_id[0]
      subscription_id = "/subscriptions/4697b4d0-df37-4199-9346-62deeb83398f" //vrk-lz-qa-001
    },

    "vrk-production-association" = {
      management_id   = module.management_group_landingzone_children.management_group_id[0]
      subscription_id = "/subscriptions/84cc2377-c8b6-45a2-8517-0efed64f8894" //vrk-lz-prod-001
    },

  }
  depends_on = [
    module.management_group_root_children,
    module.management_group_platform_children,
    module.management_group_landingzone_children
  ]
}

#------------------------------
# Module for Policies
#------------------------------

#This module creates Policy Assignments for monitoring_governance, tag_governance, iam_governance, security_governance and data_protection_governance
# For more information please visit (terraform/resources/Azure_Policy/policy-assignments/README.md)

module "policy_assignments" {
  source = "../resources/Azure_Policy/policy-assignments"

  monitoring_governance_policyset_id      = module.policyset_definitions.monitoring_governance_policyset_id
  tag_governance_policyset_id             = module.policyset_definitions.tag_governance_policyset_id
  iam_governance_policyset_id             = module.policyset_definitions.iam_governance_policyset_id
  security_governance_policyset_id        = module.policyset_definitions.security_governance_policyset_id
  data_protection_governance_policyset_id = module.policyset_definitions.data_protection_governance_policyset_id
  logging_governance_policyset_id         = module.policyset_definitions.logging_governance_policyset_id
  location                                = var.location
}

#This module creates Policy Definitions for tag_keys, tag_values, appGateway, azureFirewall etc
# For more information please visit (terraform/resources/Azure_Policy/policy-definitions/README.md)
module "policy_definitions" {
  source = "../resources/Azure_Policy/policy-definitions"

}

#This module creates Policy Definitions for monitoring_governance, tag_governance, iam_governance, security_governance and data_protection_governance
# For more information please visit (terraform/resources/Azure_Policy/policyset-definitions/README.md)

module "policyset_definitions" {
  source = "../resources/Azure_Policy/policyset-definitions"

  custom_policies_monitoring_governance = [
    { policyID = module.policy_definitions.expressRouteGateway_bitsOutPerSecond_policy_id },
    { policyID = module.policy_definitions.expressRouteGateway_bitsInPerSecond_policy_id },
    { policyID = module.policy_definitions.expressRouteCircuitPeer_bitsOutPerSecond_policy_id },
    { policyID = module.policy_definitions.expressRouteCircuitPeer_bitsInPerSecond_policy_id },
    { policyID = module.policy_definitions.expressRouteCircuit_bitsOutPerSecond_policy_id },
    { policyID = module.policy_definitions.expressRouteCircuit_bitsInPerSecond_policy_id },
    { policyID = module.policy_definitions.expressRouteCircuit_bgpAvailability_policy_id },
    { policyID = module.policy_definitions.expressRouteCircuit_arpAvailability_policy_id },
    { policyID = module.policy_definitions.sqlServerDB_storagePercent_policy_id },
    { policyID = module.policy_definitions.sqlServerDB_deadlock_policy_id },
    { policyID = module.policy_definitions.sqlServerDB_cpuPercent_policy_id },
    { policyID = module.policy_definitions.sqlServerDB_connectionFailed_policy_id },
    { policyID = module.policy_definitions.sqlServerDB_blockedByFirewall_policy_id },
    { policyID = module.policy_definitions.sqlManagedInstances_ioRequests_policy_id },
    { policyID = module.policy_definitions.sqlManagedInstances_avgCPUPercent_policy_id },
    { policyID = module.policy_definitions.appGateway_failedRequests_policy_id },
    { policyID = module.policy_definitions.appGateway_healthyHostCount_policy_id },
    { policyID = module.policy_definitions.appGateway_unhealthyHostCount_policy_id },
    { policyID = module.policy_definitions.appGateway_totalRequests_policy_id },
    { policyID = module.policy_definitions.appGateway_cpuUtilization_policy_id },
    { policyID = module.policy_definitions.appGateway_clientRTT_policy_id },
    { policyID = module.policy_definitions.websvrfarm_cpuPercentage_policy_id },
    { policyID = module.policy_definitions.websvrfarm_memoryPercentage_policy_id },
    { policyID = module.policy_definitions.website_averageMemoryWorkingSet_policy_id },
    { policyID = module.policy_definitions.website_averageResponseTime_policy_id },
    { policyID = module.policy_definitions.website_cpuTime_policy_id },
    { policyID = module.policy_definitions.website_healthCheckStatus_policy_id },
    { policyID = module.policy_definitions.website_http5xx_policy_id },
    { policyID = module.policy_definitions.website_requestsInApplicationQueue_policy_id },
    { policyID = module.policy_definitions.websiteSlot_averageMemoryWorkingSet_policy_id },
    { policyID = module.policy_definitions.websiteSlot_averageResponseTime_policy_id },
    { policyID = module.policy_definitions.websiteSlot_cpuTime_policy_id },
    { policyID = module.policy_definitions.websiteSlot_healthCheckStatus_policy_id },
    { policyID = module.policy_definitions.websiteSlot_http5xx_policy_id },
    { policyID = module.policy_definitions.websiteSlot_requestsInApplicationQueue_policy_id },
    { policyID = module.policy_definitions.azureFirewall_health_policy_id },
    { policyID = module.policy_definitions.loadBalancer_dipAvailability_policy_id },
    { policyID = module.policy_definitions.loadBalancer_vipAvailability_policy_id }
  ]

  custom_policies_tag_governance = [
    { policyID = module.policy_definitions.addTagToRG_policy_ids[0] },
    { policyID = module.policy_definitions.addTagToRG_policy_ids[1] },
    { policyID = module.policy_definitions.addTagToRG_policy_ids[2] },
    { policyID = module.policy_definitions.addTagToRG_policy_ids[3] },
    { policyID = module.policy_definitions.addTagToRG_policy_ids[4] },
    { policyID = module.policy_definitions.addTagToRG_policy_ids[5] },
    { policyID = module.policy_definitions.inheritTagFromRG_policy_ids[0] },
    { policyID = module.policy_definitions.inheritTagFromRG_policy_ids[1] },
    { policyID = module.policy_definitions.inheritTagFromRG_policy_ids[2] },
    { policyID = module.policy_definitions.inheritTagFromRG_policy_ids[3] },
    { policyID = module.policy_definitions.inheritTagFromRG_policy_ids[4] },
    { policyID = module.policy_definitions.inheritTagFromRG_policy_ids[5] },
    { policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[0] },
    { policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[1] },
    { policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[2] },
    { policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[3] },
    { policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[4] },
    { policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[5] },
    { policyID = module.policy_definitions.bulkInheritTagsFromRG_policy_id }
  ]

  custom_policies_iam_governance = [
    { policyID = module.policy_definitions.auditRoleAssignmentType_user_policy_id },
    { policyID = module.policy_definitions.auditLockOnNetworking_policy_id }
  ]

}
