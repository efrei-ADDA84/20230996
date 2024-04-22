output "vm_public_ip_address" {
  value       = azurerm_public_ip.vm_public_ip.ip_address
  description = "The public IP address of the VM."
}