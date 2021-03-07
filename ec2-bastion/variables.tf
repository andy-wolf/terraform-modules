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

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Name of the Keypair"
  type = string
}

