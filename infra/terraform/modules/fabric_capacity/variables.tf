variable "create"              { type = bool }
variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "fabric_capacity_name"{ type = string }
variable "fabric_sku"          { type = string }
variable "admin_members"       { type = list(string) }
variable "tags"                { 
    type = map(string)
    default = {}
}
