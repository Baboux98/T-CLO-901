# This file tells Terraform which cloud provider to use (Azure)

terraform {
  required_version = "= 1.7.0"

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
