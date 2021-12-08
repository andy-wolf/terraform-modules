###################
# VPC
###################
terraform {
  backend "s3" {}
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  create_vpc = true

  name = var.name

  cidr             = var.cidr
  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  create_database_subnet_group = true

  enable_dns_hostnames = true
  enable_dns_support = true

  # Should be true if you want to provision an ecr api endpoint to the VPC
#  enable_ecr_api_endpoint = true
#  ecr_api_endpoint_security_group_ids = [module.vpc-endpoints-security-group.this_security_group_id]

  # Should be true if you want to provision an ecr dkr endpoint to the VPC
#  enable_ecr_dkr_endpoint = true
#  ecr_dkr_endpoint_security_group_ids = [module.vpc-endpoints-security-group.this_security_group_id]

  # Should be true if you want to provision a ECS endpoint to the VPC
#  enable_ecs_endpoint = true
#  ecs_endpoint_security_group_ids = [module.vpc-endpoints-security-group.this_security_group_id]

  # Should be true if you want to provision a ECS Agent endpoint to the VPC
#  enable_ecs_agent_endpoint = true
#  ecs_agent_endpoint_security_group_ids = [module.vpc-endpoints-security-group.this_security_group_id]

  # Should be true if you want to provision a ECS Telemetry endpoint to the VPC
#  enable_ecs_telemetry_endpoint = true
#  ecs_telemetry_endpoint_security_group_ids = [module.vpc-endpoints-security-group.this_security_group_id]

  # Should be true if you want to provision a CloudWatch Monitoring endpoint to the VPC
#  enable_monitoring_endpoint = true
#  monitoring_endpoint_security_group_ids = [module.vpc-endpoints-security-group.this_security_group_id]

  # Should be true if you want to provision a CloudWatch Events endpoint to the VPC
#  enable_events_endpoint = true
#  events_endpoint_security_group_ids = [module.vpc-endpoints-security-group.this_security_group_id]

  # Should be true if you want to provision a CloudWatch Logs endpoint to the VPC
#  enable_logs_endpoint = true
#  logs_endpoint_security_group_ids = [module.vpc-endpoints-security-group.this_security_group_id]

  # EFS
#  enable_efs_endpoint = true
#  efs_endpoint_security_group_ids = [module.vpc-endpoints-security-group.this_security_group_id]

  enable_nat_gateway = false
  single_nat_gateway = true

  tags = merge(
    {
      "Name" = var.name
    }
  )

  igw_tags = { "Name" = "${var.name}-igw" }
  nat_gateway_tags = { "Name" = "${var.name}-nat-gw" }
  nat_eip_tags = { "Name" = "${var.name}-nat-eip" }
  private_subnet_tags = { "Name" = "${var.name}-private-subnet" }
  private_acl_tags = { "Name" = "${var.name}-private-acl" }
  private_route_table_tags = { "Name" = "${var.name}-private-rt" }
  public_subnet_tags = { "Name" = "${var.name}-public-subnet" }
  public_acl_tags = { "Name" = "${var.name}-public-acl" }
  public_route_table_tags = { "Name" = "${var.name}-public-rt" }
  database_subnet_tags = { "Name" = "${var.name}-db-subnet" }
  database_acl_tags = { "Name" = "${var.name}-db-acl" }
  database_route_table_tags = { "Name" = "${var.name}-db-rt" }
  vpc_tags = { "Name" = var.name }
#  vpc_endpoint_tags = { "Name" = "${var.name}-vpc-endpoint" }
}

