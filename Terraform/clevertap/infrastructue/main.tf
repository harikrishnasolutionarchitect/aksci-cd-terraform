###################################################################################################################
# PROVIDERS
###################################################################################################################

provider "azurerm" {
  version         = "2.32.0"
  subscription_id = var.subscription_id
  features {}
}

provider "azurerm" {
  alias           = "ops"
  version         = "2.32.0"
  subscription_id = var.ops_subscription_id
  features {}
}

provider "cloudflare" {
  version = "2.6.0"
  email   = var.cloudflare_email
}

resource "azurerm_resource_group" "rg" {
  name     = module.naming_conventions.resource_group_name
  location = var.location
  tags     = module.naming_conventions.tags_data_classification_3N
}

###################################################################################################################
# STANDARD AS CODE
###################################################################################################################
module "naming_conventions" {
  source        = "s3::https://s3.amazonaws.com/clevertap-terraform-artifacts/azurerm-naming-conventions-sf-0.12.0.zip"
  environment   = var.environment
  product       = var.product
  customer      = var.customer
  terraform     = "terraform/transportation/clevertap/${var.location}/apps/clevertap-infrastructure"
  infra_version = var.infra_version
  labels        = [""]
}

module "naming_conventions_app_registration" {
  source        = "s3::https://s3.amazonaws.com/clevertap-terraform-artifacts/azurerm-naming-conventions-sf-0.14.3.zip"
  environment   = var.environment
  product       = "clevertap-api"
  customer      = var.customer
  terraform     = "terraform/transportation/clevertap/${var.location}/apps/clevertap-infrastructure"
  infra_version = var.infra_version
  labels        = ["clevertap-api"]
}

locals {
  mariadb_server_name = module.naming_conventions.mariadb_database_name[""]
}
