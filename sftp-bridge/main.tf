###################
# sftp-bridge.tf
###################

terraform {
  backend "s3" {}
}

###
# Lambda function
###
resource "aws_lambda_function" "s3_sftp_bridge_lambda" {
  s3_bucket     = var.lambda_s3_bucket
  s3_key        = var.lambda_s3_key
  function_name = "s3-sftp-bridge-${var.name}"
  description   = "Used to sync files between S3 and SFTP servers"
  runtime       = "nodejs4.3"
  role          = aws_iam_role.lambda_role.arn
  handler       = var.lambda_handler

  lifecycle {
    ignore_changes = ["environment"]
  }
}

###
# Bucket Notification
###
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_sftp_bridge_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.data_bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.data_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_sftp_bridge_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

###
# IAM Roles and Policies
###
resource "aws_iam_role" "lambda_role" {
  name = "s3-sftp-bridge-${var.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  role = aws_iam_role.lambda_role.id
  name = "s3_access"

  policy = <<EOF
{
  "Version"  : "2012-10-17",
  "Statement": [
    {
      "Sid"     :   "1",
      "Effect"  :   "Allow",
      "Action"  : [ "s3:CopyObject",
                    "s3:GetObject",
                    "s3:ListObjects",
                    "s3:PutObject" ],
      "Resource": [ "${var.data_bucket_arn}",
                    "${var.data_bucket_arn}/*",
                    "${var.config_bucket_arn}",
                    "${var.config_bucket_arn}/*" ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_logging" {
  role = aws_iam_role.lambda_role.id
  name = "logging"

  policy = <<EOF
{
  "Version"  : "2012-10-17",
  "Statement": [
    {
      "Sid"     :   "1",
      "Effect"  :   "Allow",
      "Action"  : [ "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents" ],
      "Resource":   "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_kms" {
  role = aws_iam_role.lambda_role.id
  name = "kms"

  policy = <<EOF
{
  "Version"  : "2012-10-17",
  "Statement": [
    {
      "Sid"     :   "1",
      "Effect"  :   "Allow",
      "Action"  :   "kms:*",
      "Resource":   "${var.config_bucket_kms_key_arn}"
    }
  ]
}
EOF
}

/*

###
# S3-Bucket for Keys
###
resource "aws_s3_bucket" "sftp_keys" {
  bucket = "s3-sftp-bridge-sftp-keys-${var.name}-${data.aws_caller_identity.current.account_id}"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Id":"PutObjPolicy",
  "Statement":[
    {
      "Sid": "DenyIncorrectEncryptionHeader",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::s3-sftp-bridge-sftp-keys-${var.name}-${data.aws_caller_identity.current.account_id}/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    },
    {
      "Sid":"DenyUnEncryptedObjectUploads",
      "Effect":"Deny",
      "Principal":"*",
      "Action":"s3:PutObject",
      "Resource":"arn:aws:s3:::s3-sftp-bridge-sftp-keys-${var.name}-${data.aws_caller_identity.current.account_id}/*",
      "Condition":{
        "StringNotEquals":{
          "s3:x-amz-server-side-encryption-aws-kms-key-id":"${var.config_bucket_kms_key_arn}"
        }
      }
    }
  ]
}
EOF

  versioning {
    enabled = var.s3_keys_versioning
  }

  tags {
    Name = "s3-sftp-bridge-sftp-keys-${var.name}-${data.aws_caller_identity.current.account_id}"
  }
}

*/
