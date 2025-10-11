locals {
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  for_each            = length(var.vnets) > 0 ? var.vnets : {}
  name                = each.value.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = each.value.address_space
  tags                = local.tags
}

resource "azurerm_subnet" "subnet" {
  for_each             = length(var.subnets) > 0 ? var.subnets : {}
  name                 = each.value.name
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet_name].name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_interface" "nic" {
  for_each            = length(var.nics) > 0 ? var.nics : {}
  name                = each.value.name
  location            = local.location
  resource_group_name = local.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "static"
  }
  tags = local.tags
}
