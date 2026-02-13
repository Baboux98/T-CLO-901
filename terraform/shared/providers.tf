# ============================================
# SHARED INFRASTRUCTURE - Terraform Provider
# ============================================
# This module creates shared resources (MySQL) used by
# BOTH PaaS and IaaS in staging/prod environments.
#
# Usage:
#   terraform init
#   terraform workspace new staging   (first time only)
#   terraform workspace select staging
#   terraform apply -var-file=environments/staging.tfvars

terraform {
  required_version = "= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.59.0" # Use stable version 4.x of the Azure provider
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
