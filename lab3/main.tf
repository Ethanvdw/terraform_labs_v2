## Task 1
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.18.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "lab3" {
  name     = "RG3"
  location = "West Europe"
}

## Task 2

## Task 3

## Task 4
