###################
# variables.tf
###################

variable "name" {
  description = "Transfer server name"
  default = "transfer-server"
}

variable "gateway_ip" {
  description = "IP address of the file gateway instance"
  type = string
}

variable "cache_volume_disk_path" {
  description = "Disk path of the EBS volume used for cache"
  type = string
}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}
