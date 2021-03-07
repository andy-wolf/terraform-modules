###################
# Variables
###################

variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type    = string
}

variable "ecs_service_name" {
  type = string
}

variable "ecs_task_cpu" {
  description = "The number of cpu units used by the task"
  type        = number
  default     = 1024
}

variable "ecs_task_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = number
  default     = 8192
}

variable "container_memory_reservation" {
  description = "The amount of memory (in MiB) to reserve for the container"
  type        = number
  default     = 2048
}

variable "docker_image" {
  description = "Name of the docker image to use"
  type        = string
}

variable "custom_environment_variables" {
  description = "List of additional environment variables the container will use (list should contain maps with `name` and `value`)"
  type = list(object(
  {
    name  = string
    value = string
  }
  ))
  default = []
}

variable "custom_environment_secrets" {
  description = "List of additional secrets the container will use (list should contain maps with `name` and `valueFrom`)"
  type = list(object(
  {
    name  = string
    valueFrom = string
  }
  ))
  default = []
}

variable "volumes" {
  type = list(object({
    volumeName    = string
    rootDirectory = string
    fileSystem    = string
  }))
  default = []
}

variable "mount_points" {
  type = list(object({
    sourceVolume  = string
    containerPath = string
  }))
  default = []
}

variable "port_mappings" {
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))
  default = []
}

variable "cloudwatch_log_retention_days" {
  type = string
  default = 7
}

# For parameter store access policy
variable "environment" {
  type = string
}

# For parameter store access policy
variable "db_name" {
  type = string
}
