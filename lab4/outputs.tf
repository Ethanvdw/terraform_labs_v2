output "appgw_public_ip_address" {
  description = "The public IP address of Application Gateway."
  value       = azurerm_public_ip.pubip.ip_address
}