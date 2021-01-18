###################
# outputs.tf
###################

output "labda_function_id" {
  value = aws_lambda_function.s3_sftp_bridge_lambda.id
}

output "labda_function_arn" {
  value = aws_lambda_function.s3_sftp_bridge_lambda.arn
}
