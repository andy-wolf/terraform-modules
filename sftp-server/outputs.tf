###################
# outputs.tf
###################

output "transfer_server_arn" {
  value = aws_transfer_server.this.arn
}

output "transfer_server_id" {
  value = aws_transfer_server.this.id
}