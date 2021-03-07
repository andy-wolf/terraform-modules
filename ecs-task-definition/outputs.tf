###################
# Outputs
###################

output "task_definition_arn" {
  value = aws_ecs_task_definition.ecs-service.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_execution_role_name" {
  value = aws_iam_role.ecs_execution_role.name
}
