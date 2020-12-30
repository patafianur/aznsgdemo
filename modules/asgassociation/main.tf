resource "azurerm_network_interface_application_security_group_association" "multiasgassociation" {
 for_each =  var.multiasgassociation_settings
  network_interface_id  = each.value.network_interface_id
  application_security_group_id = each.value.resource_group_name

}