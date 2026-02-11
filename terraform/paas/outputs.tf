# ============================================
# PAAS OUTPUTS - Multi-Environment
# ============================================

output "app_url" {
  description = "URL of the deployed Laravel application"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.main.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure region"
  value       = azurerm_resource_group.main.location
}

output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "sku" {
  description = "App Service Plan SKU"
  value       = var.app_service_sku
}

output "db_type" {
  description = "Database type used"
  value       = var.use_external_db ? "External Azure MySQL (shared)" : "SQLite (in-app)"
}

output "deployment_summary" {
  description = "Summary of what was deployed"
  value       = <<-EOF
    ✅ PaaS ${var.environment} deployed!
      - App:      https://${azurerm_linux_web_app.main.default_hostname}
      - SKU:      ${var.app_service_sku}
      - Database: ${var.use_external_db ? "External MySQL (${var.external_db_host})" : "SQLite (in-app)"}
      - Docker:   ghcr.io/${lower(var.github_username)}/t-clo-901-app:latest
  EOF
}
