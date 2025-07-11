resource_group_name     = "rg-redis-example"
location                = "East US"
redis_name              = "myredisappalgorims"
redis_capacity          = 1
redis_family            = "C"
redis_sku               = "Basic"
non_ssl_port_enabled    = false
minimum_tls_version     = "1.2"
tags = {
  environment = "dev"
  team        = "devops"
}