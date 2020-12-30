/*resource "azurerm_virtual_network" "singlevnet" {
  name                = var.vnet_settings.name
  location            = var.vnet_settings.location
  resource_group_name = var.vnet_settings.resource_group_name
  address_space       = var.vnet_settings.address_space

  tags = var.vnet_settings.tags

}
*/


resource "azurerm_virtual_network" "multivnet" {
  for_each = var.multivnet_settings
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space = each.value.address_space
  tags = each.value.tags

}