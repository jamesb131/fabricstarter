locals { create = var.create ? 1 : 0 }

resource "azurerm_fabric_capacity" "cap" {
  count                = local.create
  name                 = var.fabric_capacity_name
  location             = var.location
  resource_group_name  = var.resource_group_name

  administration_members = var.admin_members

  sku {
    name = var.fabric_sku
    tier = "Fabric"
  }

  tags = var.tags
}
