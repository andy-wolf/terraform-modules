###################
# Outputs
###################

output "service_id" {
  value = aws_ecs_service.ecs-fargate-service.id
}

