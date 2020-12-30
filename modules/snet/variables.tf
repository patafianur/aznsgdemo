
variable "multisnet_settings" {
    type = map(object({
    name    = string
    resource_group_name = string
    address_prefixes = list(string)
    virtual_network_name = string
  }))
}
