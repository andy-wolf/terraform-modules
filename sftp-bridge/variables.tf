###################
# variables.tf
###################

variable "name" {
  description = "SFTP Bridge server name"
  default = "SFTP Bridge"
}

variable "lambda_s3_key" {
  default = "lambda_functions/s3-sftp-bridge.zip"
}

variable "lambda_s3_bucket" {
  default = "com.gilt.public.backoffice"
}

variable "lambda_handler" {
  default = "main.handle"
}

variable "config_bucket_kms_key_arn" {
  description = "ARN if the KMS key used to encrypt / decrypt configuration"
  type = string
}

variable "data_bucket_arn" {
  description = "ARN of the data bucket"
  type = string
}

variable "data_bucket_id" {
  description = "Id of the data bucket"
  type = string
}

variable "config_bucket_arn" {
  description = "ARN of the configuration bucket"
  type = string
}

variable "config_bucket_id" {
  description = "Id of the configuration bucket"
  type = string
}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}
