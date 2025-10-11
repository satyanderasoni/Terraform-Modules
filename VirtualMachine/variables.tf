variable "vms" {
  description = "values for vm"
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    size                 = string
    admin_username       = string
    public_key           = string
    nic_id               = string
    caching              = string
    storage_account_type = string
    publisher            = string
    offer                = string
    sku                  = string
    version              = string
  }))
}
