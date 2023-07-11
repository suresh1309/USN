variable "association" {
  description = "management & subscription association"
  type = map(object({
    management_id   = string
    subscription_id = string
  }))
  default = null
}
