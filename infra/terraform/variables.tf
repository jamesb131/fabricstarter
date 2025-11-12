variable "app" {
  description = "Short app/system name used in resource names (e.g., querious)"
  type        = string
}

variable "environment" {
  description = "Deployment environment: dev | test | prod"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region display name (e.g., Australia East)"
  type        = string
  default     = "Australia East"
}

# --- Identity / tenant ---
variable "tenant_id" {
  type = string
}

variable "deployer_object_id" {
  description = "Object ID (OID) of the SP or user that will run Terraform. Must have KV data-plane access via policy or RBAC."
  type        = string
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.deployer_object_id))
    error_message = "deployer_object_id must be a GUID OID (e.g., 00000000-0000-0000-0000-000000000000)."
  }
}

variable "admin_object_id" {
  description = "Optional human admin's OID (break-glass). May equal deployer_object_id."
  type        = string
  default     = null
}

variable "subscription_id" {
  description = "Azure subscription id to deploy into"
  type        = string
}

# --- Feature flags ---
variable "deploy_fabric_cicd_spn" {
  type    = bool
  default = true
}

variable "deploy_graph" {
  type    = bool
  default = true
}

variable "deploy_graph_mail" {
  type    = bool
  default = false
}

variable "deploy_powerbi" {
  type    = bool
  default = false
}

variable "deploy_fabric_capacity" {
  type    = bool
  default = false
}

# --- Capacity SKU ---
variable "fabric_sku" {
  type    = string
  default = "F2"
  validation {
    condition     = contains(["F2", "F4", "F8", "F16", "F32", "F64", "F128", "F256", "F512", "F1024", "F2048"], var.fabric_sku)
    error_message = "SKU must be F2..F2048."
  }
}

# --- Admin / tags ---
variable "admin_email" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "fabricstarter"
  }
}

# --- Back-compat (optional explicit names). Leave null to auto-name via locals.tf ---
variable "name_prefix" {
  description = "(Deprecated) Optional display prefix for non-Azure objects; prefer 'app'+'environment'."
  type        = string
  default     = null
}

variable "key_vault_name" {
  description = "(Optional) Explicit KV name. If null, auto-named as kv-<app>-<env>."
  type        = string
  default     = null
}

variable "fabric_capacity_name" {
  description = "(Optional) Explicit Fabric capacity name. If null, we auto-name it."
  type        = string
  default     = null
}

variable "kv_access_model" {
  description = "Use 'rbac' (Azure RBAC for data-plane) or 'policy' (legacy access policies)"
  type        = string
  default     = "policy" # ← switch back to "rbac" later when sorted
  validation {
    condition     = contains(["rbac", "policy"], var.kv_access_model)
    error_message = "kv_access_model must be 'rbac' or 'policy'."
  }
}
