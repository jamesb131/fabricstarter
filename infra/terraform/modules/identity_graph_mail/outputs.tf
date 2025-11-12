output "client_id_secret_name"       { value = var.create ? var.secret_name_client_id : null }
output "client_secret_secret_name"   { value = var.create ? var.secret_name_secret : null }
