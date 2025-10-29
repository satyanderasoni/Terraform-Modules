variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

# variable "admin_object_id" {
#   description = "Azure AD Object ID for Key Vault admin"
#   type        = string
# }

variable "keyvaults" {
  description = "Map of Key Vaults with their properties. Role: primary or dr"
  type = map(object({
    resource_group_name : string
    location : string
    role : string # primary / dr
    tags : map(string)
    enable_private_endpoint : bool # optional
    allowed_subnets : list(string) # optional subnet IDs
  }))
}

variable "sku_name" {
  description = "SKU for Key Vault"
  type        = string
  default     = "premium"
}

variable "soft_delete_days" {
  description = "Soft delete retention days"
  type        = number
  default     = 90
}

variable "purge_protection" {
  description = "Enable purge protection"
  type        = bool
  default     = true
}

variable "enable_sync" {
  description = "Enable DR secret sync"
  type        = bool
  default     = false
}
