# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  subscription_id = "cc814a2a-1202-4f0b-ab0d-802fa6e7c255"
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  name 	   = "${var.name-prefix}-${var.project}-rg"
  location = var.az_region
}

resource "azurerm_virtual_network" "net" {
  name                = "${var.project}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.name-prefix}-${var.project}-internal-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [ azurerm_virtual_network.net ]
}


