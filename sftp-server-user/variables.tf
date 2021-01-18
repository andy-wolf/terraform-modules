###################
# variables.tf
###################

variable "username" {
  description = "Transfer server user name"
  default = "user"
}

variable "server_id" {
  description = "Server id of the transfer server"
  type        = string
  default     = ""
}

variable "data_bucket_master_key_id" {
  description = "Id of KMS master key for data bucket access"
  type = string
}

variable "data_bucket_name" {
  description = "Name of the S3 bucket used as data backend"
  type        = string
}

variable "config_bucket_name" {
  description = "Name of the S3 bucket used as config backend"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}
