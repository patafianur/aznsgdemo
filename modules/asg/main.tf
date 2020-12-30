
resource "azurerm_application_security_group" "multiasg" {
  for_each = var.multiasg_settings
  name = each.value.name
  resource_group_name = each.value.resource_group_name
  location = each.value.location

}