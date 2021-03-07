###################
# ECS
###################
terraform {
  backend "s3" {}
}

data "aws_region" "current" {}

resource "aws_ecs_task_definition" "ecs-service" {
  family                   = var.name

  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  container_definitions = templatefile("./templates/ecs-container-definition.json.tpl", {
    container_name   = "${var.name}-container",
    container_image  = var.docker_image,
    container_cpu    = var.ecs_task_cpu,
    container_memory = var.ecs_task_memory,
    container_memory_reservation = var.container_memory_reservation,
    essential      = true,
    start_timeout  = 30,    // TODO: Make configurable with defaults
    stop_timeout   = 30,    // TODO: Make configurable with defaults
    portMappings   = jsonencode(var.port_mappings)
    awslogs_region = data.aws_region.current.name,
    awslogs_group  = "${var.name}-loggroup",
    environment    = jsonencode(var.custom_environment_variables),
    secrets        = jsonencode(var.custom_environment_secrets),
    mountPoints    = jsonencode(var.mount_points)
  })

  dynamic "volume" {
    for_each = var.volumes
    content {
      name = volume.value["volumeName"]
      efs_volume_configuration {
        file_system_id = volume.value["fileSystem"]
        root_directory = volume.value["rootDirectory"]
      }
    }
  }

  tags = {
    "Name" = var.name
  }
}
