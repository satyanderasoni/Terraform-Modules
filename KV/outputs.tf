output "keyvault_ids" {
  description = "Map of Key Vault resource IDs"
  value       = { for k, v in azurerm_key_vault.kv : k => v.id }
}

output "keyvault_names" {
  description = "Map of Key Vault names"
  value       = { for k, v in azurerm_key_vault.kv : k => v.name }
}

output "primary_kv" {
  description = "Primary Key Vault name"
  value       = [for k, v in var.keyvaults : k if v.role == "primary"][0]
}

output "dr_kvs" {
  description = "List of DR Key Vault names"
  value       = [for k, v in var.keyvaults : k if v.role == "dr"]
}

output "private_endpoints" {
  description = "Map of Key Vault private endpoint status"
  value       = { for k, v in var.keyvaults : k => v.enable_private_endpoint }
}
