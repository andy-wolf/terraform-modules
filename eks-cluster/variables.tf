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
  type = list(string)
}

