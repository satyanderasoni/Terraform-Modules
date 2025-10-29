output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

# ---- ACR ID ----
output "acr_id" {
  description = "The ID of the Azure Container Registry used for AKS image pulls"
  value       = azurerm_container_registry.acr.id
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}
