###################
# Outputs
###################

output "alb_security_group_id" {
  value = module.alb_sg.security_group_id
}

output "ecs_security_group" {
  value = module.ecs_sg.security_group_id
}

output "public_key_name" {
  value = aws_key_pair.mysshkey.key_name
}

