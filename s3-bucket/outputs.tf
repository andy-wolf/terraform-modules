###################
# outputs.tf
###################

output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "kms_master_key_id" {
  value = aws_kms_key.mykey.id
}

output "kms_master_key_arn" {
  value = aws_kms_key.mykey.arn
}