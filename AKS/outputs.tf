############################
# Outputs for AKS Cluster  #
############################

# ---- Cluster Name ----
output "aks_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

# ---- Cluster ID ----
output "aks_id" {
  description = "The resource ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

# ---- AKS API Server FQDN ----
output "aks_fqdn" {
  description = "The FQDN (API endpoint) of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

# ---- AKS Node Resource Group ----
output "aks_node_resource_group" {
  description = "The automatically created resource group for AKS node resources"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

# ---- Kubelet Managed Identity ----
output "aks_kubelet_identity" {
  description = "The managed identity object ID used by the AKS kubelet"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# ---- AKS Version ----
output "aks_version" {
  description = "The Kubernetes version of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kubernetes_version
}

# ---- Log Analytics Workspace ID ----
output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace for monitoring"
  value       = azurerm_log_analytics_workspace.law.id
}



# ---- Cluster Admin Credentials ----
# (Optional — use carefully, for CI/CD automation only)
output "kube_config" {
  description = "Raw Kubernetes config for admin access"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}
