###################
# variables.tf
###################

variable "name" {
  description = "Transfer server name"
  default = "transfer-server"
}

variable "identity_provider_type" {
  description = "Type of identitiy provider used within the transfer service"
  default = "SERVICE_MANAGED"
}

variable "endpoint_type" {
  description = "The endpoint type for the transfer server"
  default = "PUBLIC"
}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}
