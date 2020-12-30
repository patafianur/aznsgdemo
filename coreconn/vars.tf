

variable onpremvpnpublicip {
  default = "1.2.3.4"
}

# domena enkrypcji onprem vpn
variable onpremvpnaddrspace {
  default = ["11.12.13.0/24", "1.2.3.4/32"]
}



variable landingvnetaddrspace {
  default = ["1.9.0.0/16"]
}

variable dev1vnetaddrspace {
  default = ["11.9.0.0/17"]
}

variable test1vnetaddrspace {
  default = ["10.11.0.0/16"]
}



variable test1vnettest1snetaddrspace {
  default = ["10.11.12.0/24"]
}



variable exp1vnetmgmt1subnetaddressspace {
  default = ["1.2.3.0/24"]
}

variable admin_password {}
variable admin_username {}

variable testnetsubnets {
  default = "10.11.12.0/24"
}

locals {
  locallabels = {
    tfcode = "coreconnectivity1"

  }
}