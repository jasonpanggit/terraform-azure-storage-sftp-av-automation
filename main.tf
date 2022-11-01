resource "random_string" "name_prefix" {
  length  = 4
  special = false
  upper   = false
  lower   = true
  numeric = false
}