###################
# variables.tf
###################

variable "name" {
  description = "EC2 instance name"
  default = "storage-gateway-instance"
}

variable "instance_type" {
  description = "Instance type to use"
  default = "m4.xlarge"
}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}
