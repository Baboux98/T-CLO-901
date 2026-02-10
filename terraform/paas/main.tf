# Main Terraform configuration for PaaS deployment
# This file creates all the Azure resources needed for your Laravel app

# ============================================
# RESOURCE GROUP
# ============================================
# A resource group is a container that holds related Azure resources
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "T-CLO-901-PaaS"
    ManagedBy   = "Terraform"
  }
}

# ============================================
# APP SERVICE PLAN
# ============================================
# This defines the compute resources (CPU, memory) for your web app
# Think of it as the "server size" for your application
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux" # Laravel runs well on Linux
  sku_name            = var.app_service_sku

  tags = {
    Environment = var.environment
  }
}

# ============================================
# APP SERVICE (WEB APP)
# ============================================
# This is your actual web application hosting service
# It runs your Laravel application in a Docker container from Docker Hub
resource "azurerm_linux_web_app" "main" {
  name                = "app-${var.app_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  # Configure the application stack
  site_config {
    always_on = false # Set to false for Basic tier (required for free/basic)

    # Use Docker container from GitHub Container Registry (GHCR)
    # Free unlimited private images!
    application_stack {
      # docker_image_name   = "ghcr.io/${var.github_username}/t-clo-901-app:latest"
      # docker_registry_url = "https://ghcr.io"
      # docker_image_name        = "ghcr.io/${var.github_username}/t-clo-901-app:latest"
      docker_image_name        = "ghcr.io/${lower(var.github_username)}/t-clo-901-app:latest"
      docker_registry_url      = "https://ghcr.io"
      docker_registry_username = var.github_username
      docker_registry_password = var.github_token
    }
  }

  # Environment variables for your Laravel app
  app_settings = {
    "APP_NAME" = var.app_name
    # "APP_ENV"   = var.environment
    APP_ENV     = var.environment == "development" ? "local" : var.environment
    "APP_KEY"   = var.app_key
    "APP_DEBUG" = var.environment == "development" ? "true" : "false"
    "APP_URL"   = "https://app-${var.app_name}-${var.environment}.azurewebsites.net"

    # Database connection
    "DB_CONNECTION" = "mysql"
    "DB_HOST"       = azurerm_mysql_flexible_server.main.fqdn
    "DB_PORT"       = "3306"
    "DB_DATABASE"   = var.db_name
    "DB_USERNAME"   = var.db_admin_username
    "DB_PASSWORD"   = var.db_admin_password
    # 🔥 Kill DATABASE_URL
    DATABASE_URL = ""

    # Laravel-specific
    "LOG_CHANNEL"                         = "stderr"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"

    # GitHub Container Registry Authentication
    # I didn't understand the full story the it brought out an error
    # Error: cannot set a value for DOCKER_REGISTRY_SERVER_USERNAME in app_settings
    # "DOCKER_REGISTRY_SERVER_URL"      = "https://ghcr.io"
    # "DOCKER_REGISTRY_SERVER_USERNAME" = var.github_username
    # "DOCKER_REGISTRY_SERVER_PASSWORD" = var.github_token

    # Azure MySQL Flexible Server has this enabled by default:
    # require_secure_transport = ON
    # That means:👉 ONLY SSL/TLS connections are allowed
    # Azure provides a public CA cert.
    # Inside Azure App Service, the recommended path is:
    "MYSQL_ATTR_SSL_CA" = "/etc/ssl/certs/DigiCertGlobalRootCA.crt.pem"
  }

  tags = {
    Environment = var.environment
  }
}

# ============================================
# MYSQL FLEXIBLE SERVER
# ============================================
# Managed MySQL database service
resource "azurerm_mysql_flexible_server" "main" {
  name                   = "mysql-${var.app_name}-${var.environment}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  sku_name               = var.mysql_sku
  version                = "8.0.21" # MySQL version

  # Storage configuration
  storage {
    size_gb = 20 # 20 GB storage (minimum)
  }

  # Backup configuration
  backup_retention_days = 7

  tags = {
    Environment = var.environment
  }
}

# ============================================
# MYSQL DATABASE
# ============================================
# Create the actual database within the MySQL server
resource "azurerm_mysql_flexible_database" "main" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# ============================================
# MYSQL FIREWALL RULE
# ============================================
# Allow Azure services to access the database
resource "azurerm_mysql_flexible_server_firewall_rule" "azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0" # Special range that allows Azure services
}

# Allow your local machine to access the database (for testing/migrations)
# IMPORTANT: Replace with your actual IP address
resource "azurerm_mysql_flexible_server_firewall_rule" "dev_machine" {
  name                = "AllowDevMachine"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"         # Replace with your IP
  end_ip_address      = "255.255.255.255" # Replace with your IP

  # For learning purposes, this allows all IPs
  # In production, restrict to specific IPs only!
}
