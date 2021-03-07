###################
# Variables
###################

variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type    = string
}

variable "security_group" {
  description = "Security group to be used"
  type        = string
}

variable "key_name" {
  description = "Name of the Keypair"
  type = string
}

variable "ecs_service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

variable "private_subnets" {
  type = list(string)
}

