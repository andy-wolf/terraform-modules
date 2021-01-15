###################
# outputs.tf
###################

output "transfer_server_arn" {
  value = aws_transfer_server.this.arn
}
