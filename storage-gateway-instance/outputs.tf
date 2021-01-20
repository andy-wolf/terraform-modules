###################
# outputs.tf
###################

output "instance_id" {
  value = aws_instance.storage_gateway_instance.id
}

output "instance_arn" {
  value = aws_instance.storage_gateway_instance.arn
}

output "instance_public_ip" {
  value = aws_instance.storage_gateway_instance.private_ip
}

output "instance_private_ip" {
  value = aws_instance.storage_gateway_instance.private_ip
}