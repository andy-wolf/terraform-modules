###################
# storage-gateway-nfs-share.tf
###################

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_storagegateway_nfs_file_share" "this" {
  client_list  = ["0.0.0.0/0"]
  gateway_arn  = var.storage_gateway_arn
  location_arn = var.data_bucket_arn
  role_arn     = aws_iam_role.transfer-role.arn

  // Give bucket owner full control
  object_acl = "bucket-owner-full-control"

  // Automated cache refresh from S3 after
  cache_attributes {
    cache_stale_timeout_in_seconds = 300
  }

  // KMS-Managed Keys (SSE-KMS)
  kms_encrypted = true
  kms_key_arn = var.kms_key_arn

  // export path
  file_share_name = "data"
}

resource "aws_iam_role" "transfer-role" {
  name                = "transfer-role"
  assume_role_policy  = data.aws_iam_policy_document.transfer-role-policy.json
}

data "aws_iam_policy_document" "transfer-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["storagegateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "transfer-s3-role-policy" {
  role       = aws_iam_role.transfer-role.name
  policy_arn = aws_iam_policy.transfer-s3-policy.arn
}

resource "aws_iam_policy" "transfer-s3-policy" {
  name = "transfer-s3-policy"
  policy = data.aws_iam_policy_document.transfer-s3-policy.json
}

data "aws_iam_policy_document" "transfer-s3-policy" {
  statement {
    actions = [
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:ListBucketMultipartUploads"
    ]

    resources = [
      var.data_bucket_arn}
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectVersion",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "${var.data_bucket_arn}/*",
    ]

    effect = "Allow"
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      "arn:aws:kms:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:key/${var.kms_key_id}"
    ]

    effect = "Allow"
  }
}
