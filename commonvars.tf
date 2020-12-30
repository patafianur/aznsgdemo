variable "commonprefixes" {
  type = map
  default = {

    vm_name_prefix         = "vm-"
    if_name_prefix         = "if-"
    ip_name_prefix         = "ip-"
    vnet_name_prefix       = "vnet-"
    snet_name_prefix       = "snet-"
    gw_name_prefix         = "gw-"
    nsg_name_prefix        = "nsg-"
    asg_name_prefix        = "asg-"
    mgmtgroups_name_prefix = "mg-"
    udr_name_prefix        = "udr-"


  }

}

variable mgmt_group_name {
  default = "core1"
}

variable resource_group_name {
  default = "core-connectivity1"
}

variable location {
  default = "westeurope"
}

variable commonlabels {
  type = map
  default = {
    owner   = "XXXX"
    creator = "Terraform"
    app     = "coreconnectivity"
    layer   = "testy"
    env     = "PRD"
  }
}

variable vpn1preshare {}