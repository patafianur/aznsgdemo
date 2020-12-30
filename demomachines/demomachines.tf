# stawianie maszyn demowych w zpeerowanych vnetach
# 20201105JG


data "azurerm_resource_group" "coreconnectivity" {
  name = var.resource_group_name
}


locals{

  testnet_prefix = data.azurerm_subnet.test1test1snet.address_prefix

  testihost1ip = cidrhost(local.testnet_prefix,10)
  testihost2ip = cidrhost(local.testnet_prefix,11)

}


data "azurerm_virtual_network" "test1vnet" {
  name                = "${var.commonprefixes["vnet_name_prefix"]}testvnet1"
  resource_group_name  =  data.azurerm_resource_group.coreconnectivity.name
}

data "azurerm_subnet" "test1test1snet" {
  name                = "${var.commonprefixes["snet_name_prefix"]}testsnet1"
  virtual_network_name = data.azurerm_virtual_network.test1vnet.name
  resource_group_name  =  data.azurerm_resource_group.coreconnectivity.name
}



/*
data "azurerm_subnet" "exposedsnet1" {
  name                = "${var.commonprefixes["snet_name_prefix"]}exposedsnet1"
  #name                 = "${local.snet_name_prefix}exposedsnet1"
  virtual_network_name = data.azurerm_virtual_network.exposedvnet1.name
  resource_group_name  =  data.azurerm_resource_group.coreconnectivity.name
}
*/

#######################################################################################################
######### interface

resource "azurerm_network_interface" "main" {
  #name                = "${local.if_name_prefix}landingmachine"
  name                = "${var.commonprefixes["if_name_prefix"]}testmachine1"
  location            = data.azurerm_resource_group.coreconnectivity.location
  resource_group_name = data.azurerm_resource_group.coreconnectivity.name
  tags = merge(var.commonlabels,local.locallabels,{demolabel1="1"})

  ip_configuration {
    name                = "${var.commonprefixes["ip_name_prefix"]}vmtest1"
    subnet_id                     = data.azurerm_subnet.test1test1snet.id
    private_ip_address_allocation = "Static"
    #private_ip_address = var.testmachine1ip
    private_ip_address = local.testihost1ip
    public_ip_address_id = azurerm_public_ip.exposedmachine.id

  }
}

resource "azurerm_network_interface" "main2" {
  #name                = "${local.if_name_prefix}devmachine"
  name                = "${var.commonprefixes["if_name_prefix"]}testmachine2"
  location            = data.azurerm_resource_group.coreconnectivity.location
  resource_group_name = data.azurerm_resource_group.coreconnectivity.name
  tags = merge(var.commonlabels,local.locallabels,{demolabel1="1"})

  ip_configuration {
    #name                          = "${local.ip_name_prefix}vmdev"
    name                = "${var.commonprefixes["ip_name_prefix"]}vmtest2"
    subnet_id                     = data.azurerm_subnet.test1test1snet.id
    private_ip_address_allocation = "Static"
    private_ip_address = local.testihost2ip
  }
}



# publiczny ip


resource "azurerm_public_ip" "exposedmachine" {
  name                = "${var.commonprefixes["ip_name_prefix"]}testmachine1"
    location            = data.azurerm_resource_group.coreconnectivity.location
  resource_group_name = data.azurerm_resource_group.coreconnectivity.name
  allocation_method   = "Dynamic"

  tags = merge(var.commonlabels,local.locallabels,{demolabel1="1"})

  }




################################################################################################
# asocjacja nsg/asg z interface

resource "azurerm_network_interface_security_group_association" "vm1" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.vm-nsg.id
  depends_on = [azurerm_network_security_group.vm-nsg]
}

resource "azurerm_network_interface_security_group_association" "vm2" {
  network_interface_id      = azurerm_network_interface.main2.id
  network_security_group_id = azurerm_network_security_group.vm-nsg.id
  depends_on = [azurerm_network_security_group.vm-nsg]
}


# asocjacja nsg z snetem

resource "azurerm_subnet_network_security_group_association" "snetnsg" {
  subnet_id                 = data.azurerm_subnet.test1test1snet.id
  network_security_group_id = azurerm_network_security_group.snet-nsg.id
}

##################################################################################################
############################# maszyny
resource "azurerm_linux_virtual_machine" "testmachine1" {
  name                = "${var.commonprefixes["vm_name_prefix"]}testmachine1"
  resource_group_name = data.azurerm_resource_group.coreconnectivity.name
  location            = data.azurerm_resource_group.coreconnectivity.location
  size                = var.testmachinesize["small"]
  #size                = "Standard_DS1_v2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  tags = merge(var.commonlabels,local.locallabels,{demolabel1="1"})


  disable_password_authentication = "false"
  admin_password = var.admin_password

  os_disk   {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   source_image_reference  {
    publisher = var.testmachineimage["publisher"]
    offer     =  var.testmachineimage["offer"]
    sku       =  var.testmachineimage["sku"]
    version       =  var.testmachineimage["version"]

  }

}


resource "azurerm_linux_virtual_machine" "testmachine2" {
  #name                = "${local.vm_name_prefix}testmachine2"
  name                = "${var.commonprefixes["vm_name_prefix"]}testmachine2"
  resource_group_name = data.azurerm_resource_group.coreconnectivity.name
  location            = data.azurerm_resource_group.coreconnectivity.location
  size                = var.testmachinesize["small"]
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.main2.id,
  ]

 tags = merge(var.commonlabels,local.locallabels,{demolabel1="1"})



  disable_password_authentication = "false"
  admin_password = var.admin_password

  os_disk   {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   source_image_reference  {
    publisher = var.testmachineimage["publisher"]
    offer     =  var.testmachineimage["offer"]
    sku       =  var.testmachineimage["sku"]
    version       =  var.testmachineimage["version"]

  }

}

