###################
# variables.tf
###################

variable "name" {
  description = "EC2 instance name"
  default = "instance"
}

variable "instance_type" {
  description = "Instance type to use"
  default = "t2.micro"
}

#variable "security_group" {
#  description = "Security group to add this instance to"
#  type = string
#}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}
