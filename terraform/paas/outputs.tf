# Outputs display important information after deployment
# Think of these as "return values" from your Terraform deployment

# URL where your Laravel app will be accessible
output "app_url" {
  description = "URL of the deployed Laravel application"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

# App Service name
output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.main.name
}

# MySQL server hostname
output "mysql_server_fqdn" {
  description = "Fully qualified domain name of MySQL server"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

# MySQL database name
output "mysql_database_name" {
  description = "MySQL database name"
  value       = azurerm_mysql_flexible_database.main.name
}

# MySQL admin username
output "mysql_admin_username" {
  description = "MySQL administrator username"
  value       = var.db_admin_username
}

# Resource group name
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

# Azure region
output "location" {
  description = "Azure region where resources are deployed"
  value       = azurerm_resource_group.main.location
}

# Note: We don't output tokens for security reasons
# You can always reference them from your terraform.tfvars if needed