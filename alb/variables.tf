###################
# Variables
###################

variable "certificate_domain_name" {
  description = "The domain name of the SSL certificate e.g example.com"
  type = string
}

variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type    = string
}

variable "vpc_id" {
  description = "ID of the VPC "
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnets ids inside the VPC"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of one or more security groups to be added to the load balancer"
  type        = list(string)
  default     = []
}

variable "alb_logging_enabled" {
  description = "Controls if the ALB will log requests to S3."
  type        = bool
  default     = false
}

variable "alb_log_bucket_name" {
  description = "S3 bucket (externally created) for storing load balancer access logs. Required if alb_logging_enabled is true."
  type        = string
  default     = ""
}

variable "alb_log_location_prefix" {
  description = "S3 prefix within the log_bucket_name under which logs are stored."
  type        = string
  default     = ""
}

variable "http_port" {
  description = "Local port Atlantis should be running on. Default value is most likely fine."
  type        = number
  default     = 80
}









