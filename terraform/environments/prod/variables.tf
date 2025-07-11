variable "resource_group_name" {}
variable "location" {}
variable "redis_name" {}
variable "redis_capacity" {}
variable "redis_family" {}
variable "redis_sku" {}
variable "non_ssl_port_enabled" {
  type    = bool
  default = false
}
variable "minimum_tls_version" {
  default = "1.2"
}
variable "tags" {
  type = map(string)
  
}