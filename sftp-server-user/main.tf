###################
# sftp-server-user.tf
###################

terraform {
  backend "s3" {}
}

resource "aws_transfer_user" "user" {
  server_id = var.server_id
  user_name = var.username
  role      = aws_iam_role.user_role.arn

  #home_directory = "/${var.bucket_name}/sftp-server/${var.username}/"
  home_directory_type = "LOGICAL"
  home_directory_mappings = [{
    entry = "/"
    target = "/${var.bucket_name}/sftp-server/${var.username}/"
  }]

  tags = {
    Name = "${var.server_id}-user-${var.username}"
  }
}

resource "aws_iam_role" "user_role" {
  name = "${var.server_id}-user-role-${var.username}"

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

