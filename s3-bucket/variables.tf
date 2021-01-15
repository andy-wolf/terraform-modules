###################
# variables.tf
###################

variable "name" {
  description = "Name"
  default = "name"
}

variable "folders" {
  description = "Optional list of folders to create"
  default = []
}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}
