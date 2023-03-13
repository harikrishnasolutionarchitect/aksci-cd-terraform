###################################################################################################################
# PROVIDERS
###################################################################################################################

provider "azurerm" {
  version         = "=2.18.0"
  subscription_id = var.subscription_id
  features {}
}

provider "helm" {
  version = "1.1.1"
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.data_aks_kubernetes_cluster.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.data_aks_kubernetes_cluster.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.data_aks_kubernetes_cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.data_aks_kubernetes_cluster.kube_config.0.cluster_ca_certificate)
    load_config_file       = false
  }
}

provider "vault" {
  version = "2.18.0"
}

###################################################################################################################
# PROVIDER DEPENDENCIES
###################################################################################################################

module "aks_naming_conventions" {
  source        = "s3::https://s3.amazonaws.com/clevertap-terraform-artifacts/azurerm-naming-conventions-csf-0.1.0.zip"
  environment   = var.environment
  customer      = var.customer
  infra_version = ""
  terraform     = ""
  service       = "aks"
  labels        = []
}

data "azurerm_kubernetes_cluster" "data_aks_kubernetes_cluster" {
  name                = module.aks_naming_conventions.aks_name[""]
  resource_group_name = module.aks_naming_conventions.resource_group_name
}

###################################################################################################################
# STANDARD AS CODE - CURRENT DEPLOYMENT
###################################################################################################################

module "naming_conventions" {
  source        = "s3::https://s3.amazonaws.com/clevertap-terraform-artifacts/azurerm-naming-conventions-sf-0.14.0.zip"
  environment   = var.environment
  product       = var.product
  terraform     = var.terraform
  infra_version = var.infra_version
  labels        = ["clevertap-api"]
}
