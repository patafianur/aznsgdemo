
variable "multiasgassociation_settings" {
    type = map(object({
    name    = string
    resource_group_name = string
  }))
}
