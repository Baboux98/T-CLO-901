# This file tells Terraform which cloud provider to use (Azure)

terraform {
  required_version = "= 1.14.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.59.0" # Use stable version 4.x of the Azure provider
    }
  }
}

# Configure the Azure provider
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id

  # Make sure you run 'az login' before using Terraform
}

resource "azurerm_linux_web_app" "main" {
  name                = local.is_dev ? "app-${var.app_name}" : "app-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    # F1 (free) requires always_on = false
    # B1 can have always_on = true (keeps app warm)
    always_on = local.is_dev ? false : true

    application_stack {
      docker_image_name        = "ghcr.io/${lower(var.github_username)}/t-clo-901-app:latest"
      docker_registry_url      = "https://ghcr.io"
      docker_registry_username = var.github_username
      docker_registry_password = var.github_token
    }
  }

  # Environment variables for Laravel
  # Merged from common settings + environment-specific DB settings
  app_settings = merge(
    # ── Common settings (all environments) ──
    {
      "APP_NAME"  = var.app_name
      "APP_ENV"   = local.is_dev ? "local" : var.environment
      "APP_KEY"   = var.app_key
      "APP_DEBUG" = local.is_dev ? "true" : "false"
      "APP_URL"   = "https://app-${var.app_name}-${var.environment}.azurewebsites.net"

      "LOG_CHANNEL"                         = "stderr"
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false" # Disable persistent storage for Docker containers
    },
    {
      "DB_CONNECTION" = "mysql"
      "DB_HOST"       = var.external_db_host
      "DB_PORT"       = "3306"
      "DB_DATABASE"   = var.db_name
      "DB_USERNAME"   = var.db_admin_username
      "DB_PASSWORD"   = var.db_admin_password

      # "MYSQL_ATTR_SSL_CA" = "/etc/ssl/certs/DigiCertGlobalRootCA.crt.pem"
      "MYSQL_ATTR_SSL_CA" = "/etc/ssl/certs/ca-certificates.crt"

    }
  )

  tags = {
    Environment = var.environment
    Project     = "T-CLO-901"
  }
}