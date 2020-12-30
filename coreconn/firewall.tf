/*
module "multisnet_2" {
  source = "../modules/snet"
  depends_on = [module.multivnet_1]

  multisnet_settings = {
    "firewallsnet" = {
      name                 = "AzureFirewallSubnet"
      resource_group_name  = azurerm_resource_group.coreconnectivity.name
      address_prefixes     = var.landingvnetfwsubnetaddrspace
      virtual_network_name = "${var.commonprefixes["vnet_name_prefix"]}landingvnet"
      tags = merge(var.commonlabels, local.locallabels, { merge1 = "f", merge2 = "z" })
    }

  }
}


resource "azurerm_public_ip" "firewallip" {
  name                = "${var.commonprefixes.if_name_prefix}firewall"
  location            = azurerm_resource_group.coreconnectivity.location
  resource_group_name = azurerm_resource_group.coreconnectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
   tags = merge(var.commonlabels, local.locallabels, { merge1 = "f", merge2 = "z" })
}




resource "azurerm_firewall" "testowyfirewall" {
  depends_on = [module.multisnet_2]
  name                = "fw-testfirewall"
  location            = azurerm_resource_group.coreconnectivity.location
  resource_group_name = azurerm_resource_group.coreconnectivity.name
   tags = merge(var.commonlabels, local.locallabels, { merge1 = "f", merge2 = "z" })

  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.multisnet_2.instances["firewallsnet"].id
    public_ip_address_id = azurerm_public_ip.firewallip.id
  }
}
*/