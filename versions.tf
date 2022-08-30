terraform {
  required_version = ">= 1.2.8" # Also update terraform version in .github/workflows/pre-commit.yml

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
