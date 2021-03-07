###################
# Variables
###################

variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type    = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "instance_class" {
  description = "Instance class for the database instance"
  type        = string
  default     = "db.t2.micro"
}

variable "allowed_security_group" {
  type = string
}

variable "environment" {
  description = "The name  of the environment"
  type        = string
  default     = "dev"
}

variable "database_subnet_group" {
  type = string
}

variable "allocated_storage" {
  type = number
  default = 20
}

variable "storage_type" {
  type = string
  default = "gp2"
}

variable "database_name" {
  type = string
}

variable "user_name" {
  type = string
}

variable "user_password" {
  type = string
}

variable "allow_major_version_upgrade" {
  type = bool
}

variable "auto_minor_version_upgrade" {
  type = bool
}

variable "backup_retention_period" {
  type = number
}

variable "backup_window" {
  type = string
}

variable "maintenance_window" {
  type = string
}

variable "multi_az" {
  type = bool
  default = false
}

variable "skip_final_snapshot" {
  type = bool
  default = true
}
