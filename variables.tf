variable "subscription_id" {
  description = "The Azure Subscription ID to deploy to"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "example-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "AustraliaEast"
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = "example-kv"
}

variable "deploy_powerbi" {
  description = "Whether to deploy Power BI App Registration"
  type        = bool
  default     = true
}

variable "deploy_graph" {
  description = "Whether to deploy Graph API App Registration"
  type        = bool
  default     = true
}

variable "deploy_graph_mail" {
  description = "Whether to deploy Graph API Mail App Registration"
  type        = bool
  default     = true
}

variable "deploy_fabric_capacity" {
  description = "Whether to deploy Microsoft Fabric Capacity"
  type        = bool
  default     = true
}

variable "fabric_capacity_name" {
  description = "Name of the Fabric Capacity"
  type        = string
  default     = "example-fabric"
}

variable "fabric_sku" {
  description = "The SKU name for the Fabric Capacity."
  type        = string

  validation {
    condition = contains([
      "F2", "F4", "F8", "F16",
      "F32", "F64", "F128", "F256",
      "F512", "F1024", "F2048"
    ], var.fabric_sku)
    error_message = "SKU must be one of: F2, F4, F8, F16, F32, F64, F128, F256, F512, F1024, F2048."
  }

  default = "F4"
}

variable "admin_email" {
  description = "Admin email for Fabric Capacity"
  type        = string
}
