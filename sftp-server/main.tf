###################
# sftp-server.tf
###################

terraform {
  backend "s3" {}
}

resource "aws_transfer_server" "this" {
  identity_provider_type = var.identity_provider_type
  logging_role           = aws_iam_role.logging.arn

  endpoint_type = var.endpoint_type

  tags = {
    "Name" = var.name
  }
}

resource "aws_iam_role" "logging" {
  name = "${var.name}-logging-role"

  assume_role_policy    = data.aws_iam_policy_document.logging.json
  force_detach_policies = true

  tags = {
    "Name" = "${var.name}-logging-role"
  }
}

data "aws_iam_policy_document" "logging" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["transfer.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "logging_role" {
  name = "${var.name}-logging-role-policy"
  role = aws_iam_role.logging.id

  policy = data.aws_iam_policy_document.logging_role.json
}

data "aws_iam_policy_document" "logging_role" {
  statement {
    sid    = "SFTPLoggingTrust"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}





