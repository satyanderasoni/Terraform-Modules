output "storage_accounts" {
  description = "Details of all created storage accounts"
  value = {
    for k, v in azurerm_storage_account.storage_account : k =>
    {
      name                     = v.name
      resource_group_name      = v.resource_group_name
      location                 = v.location
      account_tier             = v.account_tier
      account_replication_type = v.account_replication_type
    }
  }
}
