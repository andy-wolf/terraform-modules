###data "aws_caller_identity" "current" {}
###data "aws_region" "current" {}

/*
 * ecs_task_role
 * You must create an IAM policy for your tasks to use
 * that specifies the permissions that you would like
 * the containers in your tasks to have.
 *
 * If you have multiple task definitions or services that
 * require IAM permissions, you should consider creating
 * a role for each specific task definition or service
 * with the minimum required permissions for the tasks to
 * operate so that you can minimize the access that you
 * provide for each task.
 */
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_policy.json

  tags = merge(
  {
    "Name" = "${var.name}-task-role"
  }
  )
}

data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    sid = "3"

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

/*  statement {
    sid = "4"

    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.name}-task-role"
      ]
    }
  }*/
}

/*
 * ECS S3 Access Role Policy
 */
data "aws_iam_policy_document" "ecs_access_s3_role_policy" {
  statement {
    sid = "2"

    actions = [
      "s3:*",
    ]

    effect = "Allow"

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "ecs-access-s3-policy" {
  name = "${var.name}-access-s3-policy"
  description = "Policy for having ECS instances access to S3 Buckets"
  path = "/"
  policy = data.aws_iam_policy_document.ecs_access_s3_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-access-s3-policy-attachment" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs-access-s3-policy.arn
}


/*
 * ecs-access-code-commit-policy
 */
resource "aws_iam_role_policy_attachment" "ecs_task_role_code_commit_policy_attachment" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

/*
 * ecs-access-code-deploy-policy
 */
resource "aws_iam_role_policy_attachment" "ecs_task_role_code_deploy_policy_attachment" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployDeployerAccess"
}

/*
 * ecs-access-parameter-store-policy
 */
resource "aws_iam_role_policy_attachment" "ecs_task_role_parameter_store_policy_attachment" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

/*
 * ecs-container-service-policy
 */
resource "aws_iam_role_policy_attachment" "ecs_task_role_container_service_policy_attachment" {
  role = aws_iam_role.ecs_task_role.name
  #policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess"
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"

}

/*
 * ecs-container-registry-policy
 */
resource "aws_iam_role_policy_attachment" "ecs_task_role_container_registry_policy_attachment" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

