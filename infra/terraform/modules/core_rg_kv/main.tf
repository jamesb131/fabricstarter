locals {
  caller_oid        = var.deployer_object_id
  admin_oid         = coalesce(var.admin_object_id, "")
  admin_is_distinct = length(local.admin_oid) > 0 && lower(local.admin_oid) != lower(local.caller_oid)
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_key_vault" "kv" {
  name                         = var.key_vault_name
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  tenant_id                    = var.tenant_id
  sku_name                     = "standard"
  rbac_authorization_enabled   = false
  purge_protection_enabled     = false
  soft_delete_retention_days   = 7
  public_network_access_enabled = true
  tags = var.tags
}

# Deployer (the TF runner) — full secret perms
resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id        = azurerm_key_vault.kv.id
  tenant_id           = var.tenant_id
  object_id           = local.caller_oid
  secret_permissions  = ["Get","List","Set","Delete"]
}

# Optional human admin (skip if same as deployer)
resource "azurerm_key_vault_access_policy" "admin" {
  count               = local.admin_is_distinct ? 1 : 0
  key_vault_id        = azurerm_key_vault.kv.id
  tenant_id           = var.tenant_id
  object_id           = local.admin_oid
  secret_permissions  = ["Get","List","Set"]
}

resource "time_sleep" "kv_data_plane_ready" {
  depends_on      = [azurerm_key_vault_access_policy.deployer, azurerm_key_vault_access_policy.admin]
  create_duration = "30s"
}