###################
# Outputs
###################

output "etag" {
  value = aws_s3_bucket_object.jenkins_config.etag
}