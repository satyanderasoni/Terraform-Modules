resource "azurerm_storage_account" "storage_account" {
  for_each                 = var.storages
  name                     = each.value.storage_account_name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}


resource "azurerm_storage_container" "storage_container" {
  for_each              = var.storages
  name                  = each.value.container_name
  storage_account_id    = azurerm_storage_account.storage_account[each.key].id
  container_access_type = each.value.container_access_type
}
