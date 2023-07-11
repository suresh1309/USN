variable "appgw_name" {
  description = "Name of the spoke virtual network."
}
variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}
variable "subnet_id" {
  description = "Name of the resource group where the storage account belongs"
}
variable "private_ip_address" {
  description = "The Private IP Address to use for the Application Gateway."
  default     = null
}
variable "sku_name" {
  type    = string
  default = "Standard_v2"
}
variable "sku_tier" {
  type    = string
  default = "Standard_v2"
}
variable "capacity" {
  type    = number
  default = 1
}
variable "enable_http2" {
  type    = bool
  default = true
}
variable "pip_allocation_method" {
  type    = string
  default = "Static"
}
variable "pip_sku" {
  type    = string
  default = "Standard"
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over."
  type        = list(string)
  default     = null
}

# variable "waf_enabled" {
#   description = "Set to true to enable WAF on Application Gateway."
#   type        = bool
#   default     = false
# }

# variable "waf_configuration" {
#   description = "Configuration block for WAF."
#   type = object({
#     firewall_mode            = string,
#     rule_set_type            = string,
#     rule_set_version         = string,
#     file_upload_limit_mb     = number,
#     max_request_body_size_kb = number,
#   })
#   default = null
# }

# variable "managed_policies_override" {
#   description = "List of managed firewall policies overrides. See https://docs.microsoft.com/en-us/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules"
#   type = list(object({
#     rule_group_name = string,
#     disabled_rules  = list(string),
#   }))
#   default = []
# }

# variable "managed_policies_exclusions" {
#   description = "List of managed firewall policies exclusions"
#   type = list(object({
#     match_variable          = string,
#     selector_match_operator = string,
#     selector                = string,
#   }))
#   default = []
# }

# variable "custom_policies" {
#   description = "List of custom firewall policies. See https://docs.microsoft.com/en-us/azure/application-gateway/custom-waf-rules-overview."
#   type = list(object({
#     name      = string,
#     rule_type = string,
#     action    = string,
#     match_conditions = list(object({
#       match_variables = list(object({
#         match_variable = string,
#         selector       = string
#       })),
#       operator           = string,
#       negation_condition = bool,
#       match_values       = list(string),
#     }))
#   }))
#   default = []
# }

# variable "custom_error" {
#   description = "List of custom error configurations, only support status code `HttpStatus403` and `HttpStatus502`."
#   type = list(object({
#     status_code    = string,
#     error_page_url = string,
#   }))
#   default = []
# }

variable "tags" {
  type        = map(any)
  description = "A mapping of tags to assign to the resources."
  default     = {}
}