terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.35" }
    azuread = { source = "hashicorp/azuread", version = "~> 3.4" }
    random  = { source = "hashicorp/random", version = "~> 3.6" }
    time    = { source = "hashicorp/time", version = "~> 0.11" }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
provider "azuread" {
  tenant_id = var.tenant_id
}

locals {
  tags = merge(var.tags, { ManagedBy = "Terraform" })
}

data "azuread_client_config" "current" {}

/* 1) Core RG + KV */
module "core_rg_kv" {
  source              = "./modules/core_rg_kv"
  resource_group_name = local.rg_name
  location            = var.location
  key_vault_name      = local.kv_name
  tenant_id           = var.tenant_id

  deployer_object_id  = var.deployer_object_id
  admin_object_id     = var.admin_object_id

  environment         = var.environment
  tags                = local.tags_effective
}

/* 2) Fabric CI/CD SPN */
module "identity_fabric_cicd" {
  source       = "./modules/identity_fabric_cicd"
  create       = var.deploy_fabric_cicd_spn
  display_name = format("%s-fabric-cicd", local.name_prefix_effective)

  key_vault_id          = module.core_rg_kv.key_vault_id
  secret_name_client_id = "fabric-cicd-client-id"
  secret_name_secret    = "fabric-cicd-client-secret"

  depends_on = [module.core_rg_kv.kv_data_plane_ready]
}

/* 3) Graph Core SPN */
module "identity_graph_core" {
  source       = "./modules/identity_graph_core"
  create       = var.deploy_graph
  display_name = format("%s-graph-core", local.name_prefix_effective)

  key_vault_id          = module.core_rg_kv.key_vault_id
  secret_name_client_id = "graph-core-client-id"
  secret_name_secret    = "graph-core-client-secret"

  depends_on = [module.core_rg_kv.kv_data_plane_ready]
}

/* 4) Graph Mail SPN */
module "identity_graph_mail" {
  source       = "./modules/identity_graph_mail"
  create       = var.deploy_graph_mail
  display_name = format("%s-graph-mail", local.name_prefix_effective)

  key_vault_id          = module.core_rg_kv.key_vault_id
  secret_name_client_id = "graph-mail-client-id"
  secret_name_secret    = "graph-mail-client-secret"

  depends_on = [module.core_rg_kv.kv_data_plane_ready]
}

/* 5) Power BI SPN (optional; only if you need it) 
module "identity_powerbi" {
  source                = "./modules/identity_powerbi"
  create                = var.deploy_powerbi
  display_name          = format("%s-powerbi", local.name_prefix_effective)
  key_vault_id          = module.core_rg_kv.key_vault_id
  secret_name_client_id = "powerbi-client-id"
  secret_name_secret    = "powerbi-client-secret"
}
*/

/* 6) Fabric Capacity (optional) */
module "fabric_capacity" {
  source               = "./modules/fabric_capacity"
  create               = var.deploy_fabric_capacity
  resource_group_name  = module.core_rg_kv.resource_group_name
  location             = var.location
  fabric_capacity_name = local.fabric_capacity_name
  fabric_sku           = var.fabric_sku
  admin_members        = [var.admin_email]
  tags                 = local.tags_effective
}
