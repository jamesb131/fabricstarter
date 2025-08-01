terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.35"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4"
    }
  }
}

provider "azuread" {}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}


data "azurerm_client_config" "current" {}

data "azuread_user" "admin" {
  user_principal_name = var.admin_email
}

#######################
# RESOURCE GROUP
#######################

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#######################
# KEY VAULT
#######################

resource "azurerm_key_vault" "kv" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

  purge_protection_enabled    = false
  soft_delete_retention_days  = 7

  # Add yourself or your SP as an access policy
  
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "List", "Set", "Delete"]
  }

    access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_user.admin.object_id
    secret_permissions = ["Get", "List"]
  }

}

#######################
# CONDITIONAL APP REGISTRATIONS
#######################

# Power BI
resource "azuread_application" "powerbi" {
  count         = var.deploy_powerbi ? 1 : 0
  display_name  = "PowerBI-Tenant-App"

  required_resource_access {
    resource_app_id = "00000009-0000-0000-c000-000000000000"
    resource_access {
      id   = "654b31ae-d941-4e22-8798-7add8fdf049f"
      type = "Role"
    }
  }
}

resource "azuread_application_password" "powerbi_secret" {
  count                  = var.deploy_powerbi ? 1 : 0
  application_id  = azuread_application.powerbi[0].id
}

# Graph
resource "azuread_application" "graph" {
  count        = var.deploy_graph ? 1 : 0
  display_name = "Graph-API-App"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    resource_access {
      id   = "97235f07-e226-4f63-ace3-39588e11d3a1"
      type = "Role"
    }
  }
}

resource "azuread_application_password" "graph_secret" {
  count                  = var.deploy_graph ? 1 : 0
  application_id  = azuread_application.graph[0].id
}

# Graph Mail
resource "azuread_application" "graph_mail" {
  count        = var.deploy_graph_mail ? 1 : 0
  display_name = "Graph-API-Mail-App"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    resource_access {
      id   = "6be147d2-ea4f-4b5a-a3fa-3eab6f3c140a"
      type = "Role"
    }
  }
}

resource "azuread_application_password" "graph_mail_secret" {
  count                  = var.deploy_graph_mail ? 1 : 0
  application_id  = azuread_application.graph_mail[0].id
}

#######################
# STORE IN KEY VAULT
#######################

resource "azurerm_key_vault_secret" "powerbi_appid" {
  count        = var.deploy_powerbi ? 1 : 0
  name         = "PowerBI-App-ID"
  value        = azuread_application.powerbi[0].client_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "powerbi_secret" {
  count        = var.deploy_powerbi ? 1 : 0
  name         = "PowerBI-App-Secret"
  value        = azuread_application_password.powerbi_secret[0].value
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "graph_appid" {
  count        = var.deploy_graph ? 1 : 0
  name         = "Graph-App-ID"
  value        = azuread_application.graph[0].client_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "graph_secret" {
  count        = var.deploy_graph ? 1 : 0
  name         = "Graph-App-Secret"
  value        = azuread_application_password.graph_secret[0].value
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "graph_mail_appid" {
  count        = var.deploy_graph_mail ? 1 : 0
  name         = "Graph-Mail-App-ID"
  value        = azuread_application.graph_mail[0].client_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "graph_mail_secret" {
  count        = var.deploy_graph_mail ? 1 : 0
  name         = "Graph-Mail-App-Secret"
  value        = azuread_application_password.graph_mail_secret[0].value
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_fabric_capacity" "fabric_capacity" {
  count                 = var.deploy_fabric_capacity ? 1 : 0
  name                  = var.fabric_capacity_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name

  administration_members = [var.admin_email]

  sku {
    name = var.fabric_sku
    tier = "Fabric"
  }
  
}

