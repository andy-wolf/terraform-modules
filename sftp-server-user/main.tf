###################
# sftp-server-user.tf
###################

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_transfer_user" "user" {
  server_id = var.server_id
  user_name = var.username
  role      = aws_iam_role.user_role.arn

  #home_directory = "/${var.bucket_name}/sftp-server/${var.username}/"
  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry = "/"
    target = "/${var.data_bucket_name}/sftp-server/${var.username}"
  }

  tags = {
    Name = "${var.server_id}-user-${var.username}"
  }
}

resource "aws_iam_role" "user_role" {
  name = "${var.username}-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "user_role_policy" {
  name = "${var.server_id}-user-role-policy-${var.username}"
  role = aws_iam_role.user_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullAccesstoS3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

###
# User's public key
###
resource "tls_private_key" "users_key_pair" {
  algorithm   = "RSA"
  ecdsa_curve = "4096"
}

resource "aws_transfer_ssh_key" "users_public_key" {
  body      = tls_private_key.users_key_pair.public_key_openssh
  server_id = var.server_id
  user_name = aws_transfer_user.user.user_name
}

resource "aws_s3_bucket_object" "users_public_key" {
  bucket = var.config_bucket_name
  key    = "/sftp-server/${var.username}/${var.username}_rsa4096.pub"
  content = tls_private_key.users_key_pair.public_key_pem

  ### Optional as long as S3 bucket has server-side encryption enabled by default
  #kms_key_id = var.kms_key_arn
  #server_side_encryption = "aws:kms"
  #server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "users_private_key" {
  bucket = var.config_bucket_name
  key    = "/sftp-server/${var.username}/${var.username}_rsa4096.private.pem"
  content = tls_private_key.users_key_pair.private_key_pem
}


/*

{
"Sid": "Stmt1544140969635",
"Action": [
"kms:Decrypt",
"kms:Encrypt",
"kms:GenerateDataKey"
],
"Effect": "Allow",
"Resource": "arn:aws:kms:region:account-id:key/kms-key-id"
}

*/

resource "aws_iam_role_policy" "user_role_kms_policy" {
  name = "${var.server_id}-user-role-kms-policy-${var.username}"
  role = aws_iam_role.user_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAccessToKMSMasterKey",
            "Effect": "Allow",
            "Action": [
              "kms:Decrypt",
              "kms:Encrypt",
              "kms:GenerateDataKey"
            ],
            "Resource": "arn:aws:kms:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:key/${var.data_bucket_master_key_id}"
        }
    ]
}
POLICY
}