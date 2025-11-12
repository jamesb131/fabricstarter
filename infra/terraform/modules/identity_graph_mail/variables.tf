variable "create"                 { type = bool }
variable "display_name"           { type = string }
variable "key_vault_id"           { type = string }
variable "secret_name_client_id"  { type = string }
variable "secret_name_secret"     { type = string }
variable "kv_access_model" {
  description = "Use 'rbac' (Azure RBAC for data-plane) or 'policy' (legacy access policies)"
  type        = string
  default     = "policy"  # ← switch back to "rbac" later when sorted
  validation {
    condition     = contains(["rbac","policy"], var.kv_access_model)
    error_message = "kv_access_model must be 'rbac' or 'policy'."
  }
}
variable "admin_object_id" {
  type    = string
  default = null
}
