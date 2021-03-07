variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "private_route_table_ids" {
  type = list(string)
}

variable "database_route_table_ids" {
  type = list(string)
}
