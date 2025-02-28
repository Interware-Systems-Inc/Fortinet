output "fortinac_public_ips" {
  value = azurerm_public_ip.fortinac_public_ip[*].ip_address
}

output "fortinac_management_ips" {
  value = azurerm_network_interface.fortinac_mgmt_nic[*].private_ip_address
}

output "fortinac_internal_ips" {
  value = azurerm_network_interface.fortinac_internal_nic[*].private_ip_address
}
