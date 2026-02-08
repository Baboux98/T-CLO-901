# Variables allow you to customize your deployment without changing the main code
# Think of these as function parameters

# Azure subscription ID
variable "subscription_id" {
  description = "Azure subscription ID (get with: az account show --query id -o tsv)"
  type        = string
  sensitive   = true # Hide in logs
}

# Azure region where resources will be created
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "northeurope" # Change to your preferred region
}

# Name of the resource group (container for all Azure resources)
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Base name for your application (used to name various resources)
variable "app_name" {
  description = "Base name for the application"
  type        = string
}

# Environment (dev, staging, prod)
variable "environment" {
  description = "Environment name"
  type        = string
}

# MySQL database name
variable "db_name" {
  description = "MySQL database name"
  type        = string
}

# MySQL admin username
variable "db_admin_username" {
  description = "MySQL administrator username"
  type        = string
}

# MySQL admin password (IMPORTANT: Don't commit this to Git!)
variable "db_admin_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true # Hides value in Terraform output
  # You'll provide this value in terraform.tfvars
}

# Laravel APP_KEY (IMPORTANT: Don't commit this to Git!)
variable "app_key" {
  description = "Laravel application encryption key (generate with: php artisan key:generate --show)"
  type        = string
  sensitive   = true                       # Hides value in Terraform output
  default     = "base64:your-app-key-here" # Replace with actual key
}

# App Service SKU (size/pricing tier)
variable "app_service_sku" {
  description = "App Service Plan SKU"
  type        = string
  # Options: F1 (Free), B1 (Basic), S1 (Standard), P1V2 (Premium)
}

# MySQL SKU
variable "mysql_sku" {
  description = "MySQL SKU"
  type        = string
}

# GitHub Container Registry credentials (FREE unlimited private images!)
variable "github_username" {
  description = "GitHub username"
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token (PAT) with packages:read permission"
  type        = string
  sensitive   = true
}
