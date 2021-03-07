data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# CodeDeploy Configuration
resource "aws_codedeploy_app" "blue_green_app" {
  compute_platform = "ECS"
  name             = "${var.name}-app"

  depends_on = [aws_ecs_service.ecs-fargate-service]
}

resource "aws_codedeploy_deployment_group" "ecs_deployment_group" {
  app_name               = aws_codedeploy_app.blue_green_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.name}-DeploymentGroup"
  service_role_arn       = aws_iam_role.code_deploy_ecs_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 2
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = aws_ecs_service.ecs-fargate-service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.http_listener_arn]
      }

      target_group {
        name = aws_alb_target_group.target-group.0.name
      }

      target_group {
        name = aws_alb_target_group.target-group.1.name
      }
    }
  }

  depends_on = [aws_alb_target_group.target-group,
    aws_ecs_service.ecs-fargate-service]
}