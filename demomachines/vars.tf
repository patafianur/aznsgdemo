
variable admin_password {}
variable admin_username {}



variable testmachine4ip {
  default = "10.9.1.6"
}

variable testmachinesize {
   type = map
   default = {
    small = "Standard_B1s"
    medium = "Standard_DS1_v2"

  }
}

locals {
  locallabels = {
    tfcode = "demomachines"

  }
}


variable testmachineimage {
  type = map
  default = {
    publisher = "Openlogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"

  }
}
