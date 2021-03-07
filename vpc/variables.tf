###################
# Variables
###################

variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type    = string
}

variable "cidr" {
  description = "The CIDR block for the VPC which will be created"
  type        = string
  default     = ""
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
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

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type = list(string)
  default = []
}

