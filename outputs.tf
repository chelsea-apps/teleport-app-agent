output "private_key" {
  value     = tls_private_key.teleport.private_key_pem
  sensitive = true
}

output "admin_role" {
  value = aws_iam_role.admin_role.arn
}

output "dev_role" {
  value = aws_iam_role.dev_role.arn
}


