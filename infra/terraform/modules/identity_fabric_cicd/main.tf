locals { create = var.create ? 1 : 0 }

data "azuread_application_published_app_ids" "well_known" {}
data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

resource "azuread_application" "app" {
  count        = local.create
  display_name = var.display_name
}

resource "azuread_service_principal" "sp" {
  count          = local.create
  client_id      = azuread_application.app[count.index].client_id
}

resource "azuread_application_password" "pwd" {
  count          = local.create
  application_id = azuread_application.app[count.index].id
  display_name   = "terraform-${var.display_name}"
  end_date_relative       = timeadd(timestamp(), "8760h")
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_key_vault_secret" "client_id" {
  count        = local.create
  name         = var.secret_name_client_id
  value        = azuread_application.app[count.index].client_id
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "client_secret" {
  count        = local.create
  name         = var.secret_name_secret
  value        = azuread_application_password.pwd[count.index].value
  key_vault_id = var.key_vault_id
}