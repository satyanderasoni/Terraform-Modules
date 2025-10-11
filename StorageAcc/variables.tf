variable "storages" {
  description = "storage account configurations"
  type = map(object({
    storage_account_name     = string
    location                 = string
    resource_group_name      = string
    account_tier             = string
    account_replication_type = string
    container_name           = string
    container_access_type    = string
  }))
}
