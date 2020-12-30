# stawianie  core + vnet + peering + gateways + vpn
# 20201105JG

/* pousuwane sekcje z gw, vpn i calyum coreconn na potrzby demo*/

data "azurerm_subscription" "current" {
}

locals{

  testnetcidr = cidrsubnets(join("",var.test1vnettest1snetaddrspace),4,4,4)


}

resource "azurerm_resource_group" "coreconnectivity" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(var.commonlabels, local.locallabels, { merge1 = "f", merge2 = "z" })
}


resource "azurerm_management_group" "mg-core" {
  display_name = "${var.commonprefixes["mgmtgroups_name_prefix"]}${var.mgmt_group_name}"

  subscription_ids = [
    data.azurerm_subscription.current.subscription_id,
  ]
}




###################################################################
### kreowanie vnetow

module "multivnet_1" {
  source = "../modules/vnet"

  multivnet_settings = {
    "testvnet1" = {
      name                = "${var.commonprefixes["vnet_name_prefix"]}testvnet1"
      location            = azurerm_resource_group.coreconnectivity.location
      resource_group_name = azurerm_resource_group.coreconnectivity.name
      address_space       = var.test1vnetaddrspace
      tags                = merge(var.commonlabels, local.locallabels, { demolabel1 = "a", demolabel2 = "b" })
    }
/*    "devvnet1" = {
      name                = "${var.commonprefixes["vnet_name_prefix"]}devvnet1"
      location            = azurerm_resource_group.coreconnectivity.location
      resource_group_name = azurerm_resource_group.coreconnectivity.name
      address_space       = var.dev1vnetaddrspace
      tags                = merge(var.commonlabels, local.locallabels, { demolabel1 = "a", demolabel2 = "b" })

    },
    "exp1vnet" = {
      name                = "${var.commonprefixes["vnet_name_prefix"]}exposedvnet1"
      location            = azurerm_resource_group.coreconnectivity.location
      resource_group_name = azurerm_resource_group.coreconnectivity.name
      address_space       = ["10.1.0.0/16"]
      tags                = merge(var.commonlabels, local.locallabels, { demolabel1 = "a", demolabel2 = "b" })
    }

*/

  }
}


module "multisnet_1" {
  source     = "../modules/snet"
  depends_on = [module.multivnet_1]

  multisnet_settings = {
    "testsnet1" = {
      name                 = "${var.commonprefixes["snet_name_prefix"]}testsnet1"
      resource_group_name  = azurerm_resource_group.coreconnectivity.name
      address_prefixes     = var.test1vnettest1snetaddrspace
      address_prefixes     = [local.testnetcidr[0]]
      #virtual_network_name = "${var.commonprefixes["vnet_name_prefix"]}testvnet1"
      virtual_network_name = module.multivnet_1.instances["testvnet1"].name
    },
    "testsnet2" = {
      name                 = "${var.commonprefixes["snet_name_prefix"]}testsnet2"
      resource_group_name  = azurerm_resource_group.coreconnectivity.name
      address_prefixes     = [local.testnetcidr[1]]
      virtual_network_name = module.multivnet_1.instances["testvnet1"].name
    },
    "testsnet3" = {
      name                 = "${var.commonprefixes["snet_name_prefix"]}testsnet3"
      resource_group_name  = azurerm_resource_group.coreconnectivity.name
      address_prefixes     = [local.testnetcidr[2]]
      virtual_network_name = module.multivnet_1.instances["testvnet1"].name
    }

/*
    "dev1testsnet" = {
      name                 = "${var.commonprefixes["snet_name_prefix"]}dev1testsubnet"
      resource_group_name  = azurerm_resource_group.coreconnectivity.name
      address_prefixes     = var.dev1vnettestsubnetaddressspace
      virtual_network_name = module.multivnet_1.instances["devvnet1"].name
    },
     "exp1dmz1snet" = {
      name                 = "${var.commonprefixes["snet_name_prefix"]}exp1dmz1subnet"
      resource_group_name  = azurerm_resource_group.coreconnectivity.name
      address_prefixes     = var.exp1vnetdmz1subnetaddressspace
       virtual_network_name = module.multivnet_1.instances["exp1vnet"].name
    },
    "exp1mgmt1snet" = {
      name                 = "${var.commonprefixes["snet_name_prefix"]}exp1mgmt1subnet"
      resource_group_name  = azurerm_resource_group.coreconnectivity.name
      address_prefixes     = var.exp1vnetmgmt1subnetaddressspace
      virtual_network_name = module.multivnet_1.instances["exp1vnet"].name
      */

    }
}

