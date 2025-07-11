provider "azurerm" {
  features {}
}

module "redis" {
  source               = "../../modules/cache"
  resource_group_name  = var.resource_group_name
  location             = var.location
  redis_name           = var.redis_name
  redis_capacity       = var.redis_capacity
  redis_family         = var.redis_family
  redis_sku            = var.redis_sku
  non_ssl_port_enabled = var.non_ssl_port_enabled
  minimum_tls_version  = var.minimum_tls_version
  tags                 = var.tags
}