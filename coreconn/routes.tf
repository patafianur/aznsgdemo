/*#############################################
# tablice routingu

resource "azurerm_route_table" "domyslna" {
  name                          = "${var.commonprefixes.udr_name_prefix}routingdladevnet"
  location                      = azurerm_resource_group.coreconnectivity.location
  resource_group_name           = azurerm_resource_group.coreconnectivity.name
  disable_bgp_route_propagation = false

  route {
    name           = "blockdefault"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
    #    next_hop_type  = "None"
  }

  route {
    name           = "ownvnet"
    address_prefix = "10.98.0.0/17"
    next_hop_type  = "VnetLocal"
  }

  route {
    name           = "onprem1"
    address_prefix = "20.0.0.0/8"
    next_hop_type  = "VirtualNetworkGateway"
  }

  route {
    name           = "onprem2"
    address_prefix = "20.168.0.0/16"
    #next_hop_type  = "None"
    next_hop_type = "VirtualNetworkGateway"
  }

  tags = var.commonlabels
}


resource "azurerm_route_table" "firewall" {
  name                          = "${var.commonprefixes.udr_name_prefix}routingdefaultviafw"
  location                      = azurerm_resource_group.coreconnectivity.location
  resource_group_name           = azurerm_resource_group.coreconnectivity.name
  disable_bgp_route_propagation = false

  route {
    name                   = "Defaultviafw"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.2.4"
    #    next_hop_type  = "None"
  }


  tags = var.commonlabels
}


resource "azurerm_route_table" "firewalldevnet" {
  name                          = "${var.commonprefixes.udr_name_prefix}routingdodevviafw"
  location                      = azurerm_resource_group.coreconnectivity.location
  resource_group_name           = azurerm_resource_group.coreconnectivity.name
  disable_bgp_route_propagation = false

  route {
    name                   = "devviafw"
    address_prefix         = "10.10.1.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.20.2.4"
    #    next_hop_type  = "None"
  }


  tags = var.commonlabels
}


#######################################################

# asocjacja tablic routingu

resource "azurerm_subnet_route_table_association" "domyslnaviafwdev" {

  #subnet_id      = azurerm_subnet.dev1teswnet.id
  subnet_id      = module.multisnet_1.instances["dev1testsnet"].id
  #route_table_id = azurerm_route_table.domyslna.id
  route_table_id = azurerm_route_table.firewall.id
}

# asocjacja tablic routingu
resource "azurerm_subnet_route_table_association" "domyslnaviafwtest" {
  #subnet_id      = azurerm_subnet.dev1teswnet.id
  subnet_id      = module.multisnet_1.instances["testsnet1"].id
  route_table_id = azurerm_route_table.firewall.id
}

*/