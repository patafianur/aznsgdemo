
variable "multiasg_settings" {
    type = map(object({
     name   = string
      location = string
      resource_group_name = string
  }))
}
