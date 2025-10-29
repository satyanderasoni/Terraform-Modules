########################################
# Azure Kubernetes Service (AKS) Setup #
########################################
data "azurerm_client_config" "current" {}
data "azuread_group" "aks_admins" {
  display_name = "AKS-Admins" # Replace with your actual AD group name
}


# ----------------------------
# AKS Cluster Resource
# ----------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  # ---- Basic Configuration ----
  name                = var.aks_name            # AKS Cluster name
  location            = var.location            # Azure region (e.g., eastus)
  resource_group_name = var.resource_group_name # Existing resource group name
  dns_prefix          = var.dns_prefix          # DNS prefix for AKS internal FQDN

  # ---- Default (System) Node Pool ----
  # System node pool runs AKS system pods (CoreDNS, metrics-server, etc.)
  default_node_pool {
    name       = "systempool"      # Name of the default node pool
    node_count = 2                 # Initial node count
    vm_size    = "Standard_D4s_v3" # VM SKU for system nodes
    max_pods   = 110               # Max pods per node
    # node_taints = ["CriticalAddonsOnly=true:NoSchedule"]  # Optional: restrict workloads to system pods only
  }

  # ---- Identity Configuration ----
  # System-assigned managed identity for AKS
  identity {
    type = "SystemAssigned"
  }

  # ---- Network Profile ----
  # Defines how cluster networking behaves
  network_profile {
    network_plugin    = "azure"       # Use Azure CNI for advanced networking
    load_balancer_sku = "standard"    # Standard Load Balancer (required for HA)
    service_cidr      = "10.0.0.0/16" # CIDR for internal cluster services
    dns_service_ip    = "10.0.0.10"   # IP for kube-dns service
    #docker_bridge_cidr  = "172.17.0.1/16"            # Docker bridge CIDR for node communication
    outbound_type = "loadBalancer" # Control outbound internet access
  }

  # ---- RBAC + Azure AD Integration ----
  # Enforces role-based authentication via Azure AD
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    #managed                = true
    admin_group_object_ids = [data.azuread_group.aks_admins.id] # ✅ dynamic AD group lookup
  }
  # ---- Tags ----
  tags = {
    Environment = "dev"        # Environment (dev, uat, prod)
    Owner       = "DevOpsTeam" # Owner team name
    CostCenter  = "App001"     # Cost center for tracking
    ManagedBy   = "Terraform"  # Management tag
  }
}

# ----------------------------
# User Node Pool (Workload)
# ----------------------------
resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"                        # Node pool name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id # Reference AKS cluster
  vm_size               = "Standard_D4s_v3"                 # Node VM SKU
  node_count            = 3                                 # Default node count
  mode                  = "User"                            # "User" = for application pods

  # ---- Scaling ----
  min_count = 1
  max_count = 5
  #enable_auto_scaling = true # Enable cluster autoscaler

  # ---- Node Configuration ----
  os_type              = "Linux"
  orchestrator_version = azurerm_kubernetes_cluster.aks.kubernetes_version

  # ---- Labels & Taints ----
  node_labels = {
    "workload" = "apps" # Label to target workloads
  }

  # Optional example:
  # node_taints = ["app=frontend:NoSchedule"]                       # Restrict which pods can run here
}

# ----------------------------
# Log Analytics Workspace
# (Required for AKS Monitoring)
# ----------------------------
resource "azurerm_log_analytics_workspace" "law" {
  name                = "aks-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 10
}

# ----------------------------
# OMS Agent (AKS Monitoring)
# ----------------------------
resource "azurerm_kubernetes_cluster_oms_agent" "monitoring" {
  kubernetes_cluster_id      = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

# ----------------------------
# ACR Pull Permission
# (Let AKS nodes pull images from ACR)
# ----------------------------
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

# ----------------------------
# Diagnostic Settings
# (Audit + Metrics logging)
# ----------------------------
resource "azurerm_monitor_diagnostic_setting" "aks_diag" {
  name                       = "aks-diag"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "kube-audit"
    enabled  = true
  }


  # ---- Metrics ----
  enabled_metric {
    category = "AllMetrics"
    enabled  = true
  }
}
