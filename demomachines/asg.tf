module "multiasg_1" {
  source = "../modules/asg"

  multiasg_settings = {
    "reposervers" = {
      name                = "${var.commonprefixes["asg_name_prefix"]}reposervers"
      location            = data.azurerm_resource_group.coreconnectivity.location
      resource_group_name = data.azurerm_resource_group.coreconnectivity.name
      tags                = var.commonlabels
    }
  }

}

