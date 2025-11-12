variable "tenant_id"          { type = string }
variable "resource_group_name"{ type = string }
variable "location"           { type = string }
variable "key_vault_name"     { type = string }
variable "tags"               { type = map(string) }
variable "environment"        { type = string }

variable "deployer_object_id" {
  type = string
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.deployer_object_id))
    error_message = "deployer_object_id must be a GUID OID."
  }
}

variable "admin_object_id" {
  type    = string
  default = null
}
