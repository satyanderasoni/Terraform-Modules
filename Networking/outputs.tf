output "vnets" {
  description = "Details of all created vnets"
  value = {
    for k, v in azurerm_virtual_network.vnet :
    k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      address_space       = v.address_space
    }
  }
}
output "subnets" {
  description = "Details of all created subnets"
  value = {
    for k, v in azurerm_subnet.subnet :
    k => {
      name                 = v.name
      resource_group_name  = v.resource_group_name
      virtual_network_name = v.virtual_network_name
      address_prefixes     = v.address_prefixes
    }
  }
}

output "nics" {
  description = "Details of all created nics"
  value = {
    for k, v in azurerm_network_interface.nic :
    k => {
      name                = v.name
      location            = v.location
      resource_group_name = v.resource_group_name
      private_ip_address  = v.ip_configuration[0].private_ip_address
      subnet_id           = v.ip_configuration[0].subnet_id

    }
  }
}
