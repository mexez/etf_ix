variable "tenant_id" {
  description = "The Tenant ID"
  type        = string
}

variable "object_id" {
  description = "The Object ID for the Key Vault access policy"
  type        = string
}

variable "sql_admin_username" {
  description = "The SQL Administrator username"
  type        = string
}

variable "sql_admin_password" {
  description = "The SQL Administrator password"
  type        = string
  sensitive   = true
}

# variable "logic_app_name" {
#   description = "The name of the Logic App."
#   type        = string
# }

# variable "logic_app_location" {
#   description = "The location of the Logic App."
#   type        = string
# }
