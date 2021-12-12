###################
# ECS
###################
terraform {
  backend "s3" {}
}

resource "aws_ecs_service" "ecs-service" {
  name                               = var.name
  #platform_version                   = "1.4.0"
  cluster                            = var.ecs_cluster_id
  task_definition                    = var.ecs_task_definition_arn
  desired_count                      = var.ecs_service_desired_count
  launch_type                        = var.ecs_service_launch_type
  deployment_maximum_percent         = var.ecs_service_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_service_deployment_minimum_healthy_percent

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.security_group]
    assign_public_ip = false
  }

  load_balancer {
    container_name   = var.ecs_container_name
    container_port   = var.http_port
    target_group_arn = aws_alb_target_group.target-group.0.arn
  }

  # Allow external changes without Terraform plan difference
  lifecycle {
    create_before_destroy = true
    ignore_changes = [desired_count, load_balancer, task_definition]
  }

  deployment_controller {
    type = "CODE_DEPLOY"    # Valid types are "ECS" and "CODE_DEPLOY"
  }

  # depends on ALB listener!??

  tags = {
    "Name" = var.name
  }
}
