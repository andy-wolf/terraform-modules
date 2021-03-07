data "aws_caller_identity" "current" {}
###data "aws_region" "current" {}

###################
# IAM
###################
/*
 * ecs_task_execution_role
 * The Amazon ECS container agent, and the Fargate agent for your
 * Fargate tasks, make calls to the Amazon ECS API on your behalf.
 *
 * Fargate tasks require the execution role to be specified as part
 * of the task definition.
 *
 * EC2 launch type tasks don't require this because the EC2 instances
 * themselves should have an IAM role that allows them to pull the
 * container image and optionally push logs to Cloudwatch.
 */
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_role_policy.json

  tags = merge(
  {
    "Name" = "${var.name}-execution-role"
  }
  )
}

data "aws_iam_policy_document" "ecs_execution_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_attachment" {
  role = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


/*
 * ecs-access-parameter-policy
 * Grant access to ECS task for accessing the SSM Parameter Store
 */
resource "aws_iam_policy" "ecs-access-parameters-policy" {
  name = "${var.name}-access-parameters-policy"
  description = "Policy for having ECS instances access to SSM Parameter Store"
  path = "/"
  policy = data.aws_iam_policy_document.ecs-access-parameters-policy-document.json
}

data "aws_iam_policy_document" "ecs-access-parameters-policy-document" {
  statement {
    sid = "1"

    effect = "Allow"

    actions = [
      "ssm:DescribeParameters",
      "kms:Decrypt"
    ]

    resources = ["*"]
  }

  statement {
    sid = "Stmt1482841904000"

    effect = "Allow"

    actions = [
      "ssm:GetParameters"
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/database/${var.db_name}/url",
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/database/${var.db_name}/admin_user_name",
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/database/${var.db_name}/admin_user_password",
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/nexus/publisher/username",
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/nexus/publisher/password"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ecs-access-parameters-policy-attachment" {
  role = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs-access-parameters-policy.arn
}


