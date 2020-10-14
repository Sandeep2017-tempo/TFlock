terraform {
  backend "azurerm" {
    resource_group_name  = "tfstatenew"
    storage_account_name = "tfstatenew27228"
    container_name       = "tfstatenew123"
    key                  = "dev.terraform.tfstate"
  }
}


provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "terraformapp" {
  name     = "terraformapp-resources"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "terraformapp" {
  name                = "terraformapp-appserviceplan"
  location            = azurerm_resource_group.terraformapp.location
  resource_group_name = azurerm_resource_group.terraformapp.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "terraformapp" {
  name                = "terraformapp-app-service"
  location            = azurerm_resource_group.terraformapp.location
  resource_group_name = azurerm_resource_group.terraformapp.name
  app_service_plan_id = azurerm_app_service_plan.terraformapp.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=terraformapp.mydomain.com;Integrated Security=SSPI"
  }
}