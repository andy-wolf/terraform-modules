###################
# Variables
###################

variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type    = string
}

variable "vpc_id" {
  description = "ID of the VPC "
  type        = string
}

variable "http_port" {
  description = "Local port Atlantis should be running on. Default value is most likely fine."
  type        = number
  default     = 80
}

variable "public_key_file" {
  type = string
}
