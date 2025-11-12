output "resource_group_name" { value = azurerm_resource_group.rg.name }
output "key_vault_id"        { value = azurerm_key_vault.kv.id }
output "key_vault_name"      { value = azurerm_key_vault.kv.name }
output "key_vault_uri"       { value = azurerm_key_vault.kv.vault_uri }
output "kv_data_plane_ready" { value = time_sleep.kv_data_plane_ready.id}
