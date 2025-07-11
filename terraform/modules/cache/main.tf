resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_redis_cache" "redis" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku
  non_ssl_port_enabled= var.non_ssl_port_enabled
  minimum_tls_version = var.minimum_tls_version
  depends_on          = [azurerm_resource_group.rg]
  tags                = var.tags

  redis_configuration {}
}