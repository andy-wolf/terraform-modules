###################
# Outputs
###################

output "bastion_id" {
  value = aws_instance.bastion.id
}

output "bastion_ip_address" {
  value = aws_instance.bastion.public_ip
}

