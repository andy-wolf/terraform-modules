###################
# outputs.tf
###################

output "transfer_user_id" {
  value = aws_transfer_user.user.id
}

output "transfer_user_arn" {
  value = aws_transfer_user.user.arn
}
