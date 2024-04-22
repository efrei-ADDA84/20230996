# Resource pour générer la clé SSH
resource "tls_private_key" "tls_key" {
  algorithm = "RSA" # algo
  rsa_bits  = 4096
}

# Sauvegarder la clé privée dans un fichier
resource "local_file" "private_key_file" {
  content  = tls_private_key.tls_key.private_key_pem
  filename = "./id_rsa"
}

# Sauvegarder la clé publique dans un fichier
resource "local_file" "public_key_file" {
  content  = tls_private_key.tls_key.public_key_openssh
  filename = "./id_rsa.pub"
}

output "private_key_pem" {
  value     = tls_private_key.tls_key.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = tls_private_key.tls_key.public_key_openssh
}