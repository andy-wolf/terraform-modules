###################
# Jenkins config
###################
terraform {
  backend "s3" {}
}

/*
 * Upload config file to S3 bucket for CasC plugin to pickup
 */

resource "aws_s3_bucket_object" "jenkins_config" {
  bucket = var.bucket_name
  key = "config.yaml"
  source = var.config_file
  etag   = filemd5(var.config_file)
}

/*
 * Improve with feeding config file into module dynamically
 * Seems not to be possible using terragrunt for now
 */
