output "powerbi_app_id" {
  description = "Power BI App Registration ID"
  value       = var.deploy_powerbi ? azuread_application.powerbi[0].client_id : null
}

output "graph_app_id" {
  description = "Graph API App Registration ID"
  value       = var.deploy_graph ? azuread_application.graph[0].client_id : null
}

output "graph_mail_app_id" {
  description = "Graph API Mail App Registration ID"
  value       = var.deploy_graph_mail ? azuread_application.graph_mail[0].client_id : null
}

output "fabric_capacity_id" {
  description = "ID of the Fabric Capacity"
  value       = var.deploy_fabric_capacity ? azurerm_fabric_capacity.fabric_capacity[0].id : null
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.kv.vault_uri
}

output "key_vault_directory_id" {
  description = "The Azure Active Directory (tenant) ID for the Key Vault"
  value       = azurerm_key_vault.kv.tenant_id
}

output "key_vault_secret_names" {
  description = "Names of all Key Vault secrets created"
  value = compact([
    var.deploy_powerbi     ? azurerm_key_vault_secret.powerbi_appid[0].name      : null,
    var.deploy_powerbi     ? azurerm_key_vault_secret.powerbi_secret[0].name     : null,
    var.deploy_graph       ? azurerm_key_vault_secret.graph_appid[0].name        : null,
    var.deploy_graph       ? azurerm_key_vault_secret.graph_secret[0].name       : null,
    var.deploy_graph_mail  ? azurerm_key_vault_secret.graph_mail_appid[0].name   : null,
    var.deploy_graph_mail  ? azurerm_key_vault_secret.graph_mail_secret[0].name  : null
  ])
}