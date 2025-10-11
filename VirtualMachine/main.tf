resource "azurerm_linux_viretual_machine" "vm" {
  for_each            = var.vms
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  ssh_keys {
    path     = "/home/${each.value.admin_username}/.ssh/authorized_keys"
    key_data = each.value.public_key
  }
  network_interface_ids = [
    each.value.nic_id
  ]
  os_disk {
    caching              = each.value.caching
    storage_account_type = each.value.storage_account_type
  }
  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
}
