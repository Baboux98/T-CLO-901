# ============================================
# PAAS MAIN - Multi-Environment Configuration
# ============================================
# Environment behavior:
#   dev     → F1 (free) + SQLite + always_on=false
#   staging → B1 + shared external MySQL + always_on=true
#   prod    → B1 + shared external MySQL + always_on=true
#
# Usage:
#   terraform workspace select dev
#   terraform apply -var-file=environments/dev.tfvars

locals {
  is_dev = var.environment == "dev"
  env    = terraform.workspace
}

locals {
  _guard = var.environment == local.env ? true : file("ERROR_WRONG_ENV")
}
# ============================================
# RESOURCE GROUP
# ============================================
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = local.is_dev ? {} : {
    DeploymentType = "PaaS"
    Environment    = var.environment
    ManagedBy      = "Terraform"
    Project        = "T-CLO-901"
  }
}

# ============================================
# APP SERVICE PLAN
# ============================================
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku # F1 for dev, B1 for staging/prod

  tags = {
    Environment = var.environment
    Project     = "T-CLO-901"
  }
}

# ============================================
# APP SERVICE (WEB APP)
# ============================================
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
