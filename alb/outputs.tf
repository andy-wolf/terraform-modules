###################
# Outputs
###################

output "alb_target_group_arns" {
  value = module.alb.target_group_arns
}

output "alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "alb_zone_id" {
  value = module.alb.lb_zone_id
}

output "http_listener_arn" {
  value = element(module.alb.https_listener_arns, 0)
}

