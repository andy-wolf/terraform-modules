resource "aws_iam_role" "code_deploy_ecs_role" {
  name                = "${var.name}-codeDeployBlueGreenECSRole"

  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "code_deploy_ecs_policy" {
  name    = "${var.name}-codeDeployBlueGreenECSPolicy"
  role = aws_iam_role.code_deploy_ecs_role.id

  policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecs:*",
                "elasticloadbalancing:*",
                "iam:PassRole",
                "lambda:*",
                "cloudwatch:*",
                "sns:*",
                "s3:*",
                "codedeploy:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
          "Sid": "sid1",
          "Effect": "Allow",
          "Resource": [
                "${var.ecs_task_execution_role_arn}"
          ],
          "Action": "iam:PassRole"
        }
    ]
}
EOF
}
