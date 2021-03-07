###################
# IAM
###################

/*
 * ecs-ec2-container-instance-role
 * For calls of the Amazon ECS container agent to the Amazon ECS API
 * This IAM role only applies if you are using the EC2 launch type.
 */
resource "aws_iam_instance_profile" "ecs-ec2-container-instance-profile" {
  name = "ecs-ec2-container-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-ec2-container-instance-role.id
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "aws_iam_role" "ecs-ec2-container-instance-role" {
  name                = "ecs-container-instance-role"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.ecs-ec2-container-instance-policy.json
}

data "aws_iam_policy_document" "ecs-ec2-container-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-ec2-container-instance-role-attachment" {
  role       = aws_iam_role.ecs-ec2-container-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


