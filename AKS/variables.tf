variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region where AKS will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name for AKS"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for AKS cluster FQDN"
  type        = string
}
variable "acr_id" {
  description = "value for acr_id"
  type = string
}
  
}

# variable "admin_group_object_id" {
#   description = "Azure AD group object ID for AKS admins"
#   type        = string
# }
