
output "serial_numbers" {
  value = local.serial_numbers
}

output "merged" {
  value = local.merged
}

output "dc_networks" {
  value = dcnm_network.net
}
