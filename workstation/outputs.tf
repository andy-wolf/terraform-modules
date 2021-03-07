###################
# Outputs
###################

output "ssh_security_group_id" {
  value = aws_security_group.ssh_from_local.id
}

output "http_security_group_id" {
  value = aws_security_group.http_from_local.id
}
