resource_group_name      = "example2kz-rg"
location                = "AustraliaEast"
key_vault_name          = "example2-kzkv"
deploy_powerbi          = true
deploy_graph            = true
deploy_graph_mail       = true
deploy_fabric_capacity  = false
fabric_capacity_name    = "KZfccapacity"
fabric_sku              = "F4"
# subscription_id and admin_email have no defaults and must be set by the user
subscription_id       = ""
admin_email           = ""