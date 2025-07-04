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
