###################
# variables.tf
###################

variable "name" {
  description = "Transfer server name"
  default = "transfer-server"
}

variable "storage_gateway_arn" {
  description = "ARN of the storage gateway"
  type = string
}

variable "data_bucket_arn" {
  description = "ARN of the data bucket"
  type = string
}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}
