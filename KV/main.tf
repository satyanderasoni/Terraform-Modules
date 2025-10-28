data "azurerm_client_config" "current" {}

# -----------------------
# Key Vault Creation
# -----------------------
resource "azurerm_key_vault" "kv" {
  for_each = var.keyvaults

  name                       = each.key
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  sku_name                   = var.sku_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization  = true
  soft_delete_retention_days = var.soft_delete_days
  purge_protection_enabled   = var.purge_protection
  tags                       = each.value.tags

  #   dynamic "network_acls" {
  #     for_each = each.value.enable_private_endpoint ? [1] : []
  #     content {
  #       default_action             = "Deny"
  #       bypass                     = "AzureServices"
  #       virtual_network_subnet_ids = each.value.allowed_subnets
  #     }
  #   }
}

# -----------------------
# RBAC Assignment for admin
# -----------------------
resource "azurerm_role_assignment" "kv_admin" {
  for_each             = azurerm_key_vault.kv
  scope                = each.value.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.admin_object_id
}

# -----------------------
# Optional DR secret sync
# -----------------------
resource "null_resource" "kv_sync" {
  count = var.enable_sync ? length([for k, v in var.keyvaults : k if v.role == "dr"]) : 0

  depends_on = [azurerm_key_vault.kv]

  provisioner "local-exec" {
    command = <<EOT
      primary_name=$(for k, v in var.keyvaults : k if v.role == "primary")
      for dr_name in $(for k, v in var.keyvaults : k if v.role == "dr"); do
        az keyvault secret list --vault-name $primary_name --query [].id -o tsv |
        xargs -I {} az keyvault secret show --id {} |
        jq -r '.| "\(.name)=\(.value)"' |
        while IFS='=' read -r name value; do
          az keyvault secret set --vault-name $dr_name --name "$name" --value "$value";
        done
      done
    EOT
  }
}
