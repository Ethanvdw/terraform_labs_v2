terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.18.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resgrp" {
  name     = var.RG_NAME
  location = var.LOCATION
}
