output "instancje_vnetow" {
  value = {
    for instance in module.multivnet_1.instances :
    instance.name => instance.id
  }
}

output "id_vnetow" {
  value = {
    for instance in module.multivnet_1.instances :
    instance.name => instance.name
  }
}
