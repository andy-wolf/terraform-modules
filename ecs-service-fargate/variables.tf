###################
# Variables
###################

variable "vpc_id" {
  description = "ID of the VPC "
  type        = string
}

variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type    = string
}

variable "ecs_service_name" {
  type = string
}

variable "http_port" {
  description = "Local port Atlantis should be running on. Default value is most likely fine."
  type        = number
  default     = 80
}

variable "ecs_service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

variable "ecs_service_deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  type        = number
  default     = 200
}

variable "ecs_service_deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
  default     = 100
}

variable "alb_target_group_arns" {
  type = list(string)
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "security_group" {
  description = "Security group to be used"
  type        = string
}

variable "http_listener_arn" {
  type = string
}

variable "routing_url" {
  type = string
}

variable "domain_name" {
  description = "The domain name e.g example.com"
  type = string
}

variable "dns_name" {
  type = string
}

variable "ecs_task_definition_arn" {
  type = string
}

variable "ecs_container_name" {
  type = string
}

variable "health_check_uri" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}