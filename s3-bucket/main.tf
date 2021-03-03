###################
# s3-bucket.tf
###################

terraform {
  backend "s3" {}
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.name}-logs"
  acl    = "log-delivery-write"
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "this" {
  bucket = var.name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    prefix  = "config/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "INTELLIGENT_TIERING"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }

  tags = {
    Name = var.name
  }
}

# Create empty folders
resource "aws_s3_bucket_object" "folders" {
  for_each = var.folders

  bucket = aws_s3_bucket.this.id
  acl     = "private"

  key = "${trimsuffix(each.value, "/")}/"

  content_type = "application/x-directory"
  kms_key_id = aws_kms_key.mykey.arn
}


