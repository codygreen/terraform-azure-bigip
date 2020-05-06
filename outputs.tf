output bigip_password {
  value = var.bigip_password
}

output bigip_mgmt_ip {
  value = azurerm_public_ip.management_public_ip.ip_address
}
