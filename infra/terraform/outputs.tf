output "key_vault_name" { value = module.core_rg_kv.key_vault_name }
output "key_vault_id" { value = module.core_rg_kv.key_vault_id }
output "key_vault_uri" { value = module.core_rg_kv.key_vault_uri }
output "resource_group_name" { value = module.core_rg_kv.resource_group_name }

output "fabric_capacity_id" { value = module.fabric_capacity.fabric_capacity_id }

output "fabric_cicd_client_id_secret_names" {
  value = {
    client_id = module.identity_fabric_cicd.client_id_secret_name
    secret    = module.identity_fabric_cicd.client_secret_secret_name
  }
}

output "key_vault_secret_names" {
  description = "All created secret names (for convenience)"
  value = compact([
    try(module.identity_fabric_cicd.client_id_secret_name, null),
    try(module.identity_fabric_cicd.client_secret_secret_name, null),

    var.deploy_powerbi ? "powerbi-client-id" : null,
    var.deploy_powerbi ? "powerbi-client-secret" : null,
    var.deploy_graph ? "graph-core-client-id" : null,
    var.deploy_graph ? "graph-core-client-secret" : null,
    var.deploy_graph_mail ? "graph-mail-client-id" : null,
    var.deploy_graph_mail ? "graph-mail-client-secret" : null
  ])
}

output "entra_tenant_id" {
  value       = data.azuread_client_config.current.tenant_id
  description = "The Entra ID tenant ID."
}