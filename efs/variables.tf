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

variable "private_subnet_ids" {
  description = "A list of private subnets ids inside the VPC"
  type        = list(string)
  default     = []
}

variable "allowed_security_group" {
  type = string
}