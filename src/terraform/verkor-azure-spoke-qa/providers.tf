terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.94.0"
    }
  }
}
provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "Hub-Env"
  subscription_id = "11d876fb-4bde-49aa-a1b9-17c136459a45"
}