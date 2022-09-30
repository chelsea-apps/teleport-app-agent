resource "tls_private_key" "teleport" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "teleport_key" {
  key_name   = "teleport"
  public_key = tls_private_key.teleport.public_key_openssh
}
