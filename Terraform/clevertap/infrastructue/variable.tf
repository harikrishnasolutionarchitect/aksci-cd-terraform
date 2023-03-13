variable "subscription_id" {
  type        = string
  description = "Azure Subscription in which the Vault resources will be deployed in."
}

variable "clevertap_subscription_id" {
  description = "Subscription ID to deploy clevertap cloud infra"
  type        = string
}

variable "location" {
  type        = string
  description = "The Azure region the consul cluster will be deployed in."
}

variable "environment" {
  type        = string
  description = "Environment of the deployment."
}

variable "product" {
  type        = string
  description = "Product of the deployment."
  default     = "clevertap"
}

variable "customer" {
  type        = string
  description = "Customer of the deployment"
  default     = "clevertap-center"
}

variable "infra_version" {
  type        = string
  description = "Version of the terraform deployment used for this deployment."
}

variable "mariadb_server_sku" {
  type        = string
  description = "mariadb server SKU name"
  default     = "GP_Gen5_2"
}
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cloudflare_email" {
  type        = string
  description = "Email used to authenticate against cloudflare"
  default     = "devops@clevertap.com"
}

variable "mariadb_server_version" {
  type        = string
  description = "MariaDB server version"
  default     = "10.3"
}

variable "mariadb_server_storage_mb" {
  type        = string
  description = "MariaDB server storage size in megabytes"
  default     = "5120"
}

variable "mariadb_server_backup_retention_days" {
  description = "MariaDB server backup retention days"
  type        = number
  default     = 7
}

variable "databases" {
  description = "List of databases that should be bootstrapped"
  type        = list(string)
  default = [
    "clevertap_matching_violations",
    "clevertap_media_processor",
    "clevertap_ticketing_service"
  ]
}

variable "mariadb_server_firewall_rules" {
  description = "Firewall rules to append to MariaDB"
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}
}

variable "mariadb_server_vnet_rules" {
  description = "VNet rules to append to MariaDB"
  type        = map(string)
  default     = {}
}

variable "mariadb_vnet_rules_subnets" {
  description = "List of vNet properties to query the ID of the subnets to connect to mariadb"
  type = list(object({
    vnet_name   = string
    rg_name     = string
    subnet_name = string
  }))
  default = [
    {
      vnet_name   = "dev-aks-clevertap-vnet"
      rg_name     = "dev-aks-clevertap-rg"
      subnet_name = "dev-aks-cluster-clevertap-sn"
    }
  ]
}

variable "mariadb_ops_vnet_rules_subnets" {
  description = "List of vNet properties to query the ID of the subnets to connect to mariadb"
  type = list(object({
    vnet_name   = string
    rg_name     = string
    subnet_name = string
  }))
  default = [
    {
      vnet_name   = "clevertap-ciscoasavpn-vnet"
      rg_name     = "clevertap-ciscoasavpn-rg"
      subnet_name = "clevertap-ciscoasavpn-ciscoasavpn-sn"
    },
    {
      vnet_name   = "clevertap-vault-vnet"
      rg_name     = "clevertap-vault-rg"
      subnet_name = "clevertap-vault-ndcluster-sn"
    }
  ]
}

variable "mariadb_server_autogrow_enabled" {
  description = "Enable MariaDB autogrow to allow server to automatically increase volume disk size."
  type        = bool
  default     = false
}

variable "mariadb_server_geo_redundant_backup_enabled" {
  description = "Enable georeplication for backups"
  type        = bool
  default     = false
}

variable "mariadb_enabled_ssl" {
  type        = bool
  default     = true
  description = "Enable SSL for mariadb"
}
