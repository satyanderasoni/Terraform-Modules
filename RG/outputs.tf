output "rg_names" {
  description = "Resource Group name"
  value       = { for k, v in azurerm_resource_group.rg : k => v.name }
}

output "rg_ids" {
  description = "Resource Group ID"
  value       = { for k, v in azurerm_resource_group.rg : k => v.id }
}

output "rg_locations" {
  description = "Map of Resource Group Locations"
  value       = { for k, v in azurerm_resource_group.rg : k => v.location }
}
