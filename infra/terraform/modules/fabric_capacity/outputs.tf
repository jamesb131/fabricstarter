output "fabric_capacity_id" {
  value = try(azurerm_fabric_capacity.cap[0].id, null)
}
