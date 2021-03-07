terraform {
  backend "s3" {}
}

locals {
  ### database_route_table seems to be the same than private_route_table
  #route_table_ids = concat(var.private_route_table_ids, var.database_route_table_ids)
  route_table_ids = concat(var.private_route_table_ids)
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = element(var.public_subnets, 0)
  tags = {
    "Name" = "nat-gateway"
  }
}

resource "aws_route" "nat_gateway_route" {
  count = length(local.route_table_ids)
  route_table_id         = element(local.route_table_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id

  timeouts {
    create = "5m"
  }
}
