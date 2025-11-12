resource_group_name      = "example-rg" # change as required
location                = "AustraliaEast" # change as required
key_vault_name          = "examplekv" # change as required
deploy_powerbi          = false
deploy_graph            = true
deploy_graph_mail       = false
deploy_fabric_capacity  = false
fabric_capacity_name    = "fccapacity"
fabric_sku              = "F2"
# subscription_id and admin_email have no defaults and must be set by the user
subscription_id       = "" # change as required
admin_email           = "" # change to admin email