###################
# Security
###################
terraform {
  backend "s3" {}
}

resource "aws_key_pair" "mysshkey" {
  key_name   = "mysshkey"
  public_key = file(var.public_key_file)
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name        = "${var.name}-alb-sg"
  vpc_id      = var.vpc_id
  description = "Security group for load balancer"

  ### Replaced by workstation module to limit access for now!
  #ingress_cidr_blocks = ["0.0.0.0/0"]
  #ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  ###ingress_with_self = ["all-all"]
  egress_rules      = ["all-all"]

  tags = {
    "Name" = "${var.name}-alb-sg"
  }
}

module "ecs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name        = "${var.name}-ecs-sg"
  vpc_id      = var.vpc_id
  description = "Security group with open port (${var.http_port}) from ALB, egress ports are all world open"

  # Allow requests to all ports in case the request comes from the load balancer
  ingress_with_source_security_group_id = [
    {
      from_port                = "0"
      to_port                  = "65535"
      protocol                 = "tcp"
      description              = "Access from load balancer"
      source_security_group_id = module.alb_sg.this_security_group_id
    }
  ]

  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]

  ###ingress_with_self = ["all-all"]
  egress_rules = ["all-all"]

  tags = {
    "Name" = "${var.name}-ecs-sg"
  }
}

/*
resource "aws_security_group_rule" "ecs_instances_to_alb" {
  type        = "ingress"
  from_port   = "0"
  to_port     = "65535"
  protocol    = "tcp"
  description = "Access from ECS instances"

  security_group_id        = module.alb_sg.this_security_group_id
  source_security_group_id = module.ecs_sg.this_security_group_id
}
*/

module "endpoints-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name        = "${var.name}-endpoints-sg"
  vpc_id      = var.vpc_id
  description = "Security group for VPC endpoints with open port 443, egress ports are all world open"

  ingress_with_source_security_group_id = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "VPC-Endpoints"
      source_security_group_id = module.ecs_sg.this_security_group_id
    },
  ]

  egress_rules = ["all-all"]

  tags = {
    "Name" = "${var.name}-endpoints-sg"
  }
}




