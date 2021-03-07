###################
# ECS
###################
terraform {
  backend "s3" {}
}

locals {
  cluster_name = var.name
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.name

  tags = {
    "Name" = var.name
  }
}

data "aws_ssm_parameter" "image" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

data "aws_ami" "ecs" {
  #most_recent = true # get the latest version

/*  filter {
    name = "name"
    values = [
      "amzn2-ami-ecs-*"    # ECS optimized image
    ]
  }*/

  filter {
    name = "image-id"
    values = [data.aws_ssm_parameter.image.value]
  }
/*
  filter {
    name = "virtualization-type"
    values = [
      "hvm"
    ]
  }
*/

  owners = [
    "amazon" # Only official images
  ]

}

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name                        = "ecs-launch-configuration"
  image_id                    = data.aws_ami.ecs.id
  instance_type               = "t2.large"    // TODO: Remove hardcoding
  iam_instance_profile        = aws_iam_instance_profile.ecs-ec2-container-instance-profile.id

  root_block_device {
    volume_type = "standard"
    volume_size = 30
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = [var.security_group]
  associate_public_ip_address = false
  key_name                    = var.key_name
  user_data                   = <<-EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER="${var.name}" >> /etc/ecs/ecs.config
                                  EOF
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                        = "ecs-autoscaling-group"
  max_size                    = 2
  min_size                    = 1
  desired_capacity            = var.ecs_service_desired_count
  vpc_zone_identifier         = var.private_subnets
  launch_configuration        = aws_launch_configuration.ecs-launch-configuration.name
  health_check_type           = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_policy" "ecs-scaling-policy" {
  name                      = "ecs-scaling-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.ecs-autoscaling-group.name
  estimated_instance_warmup = 60

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "70"
  }
}


