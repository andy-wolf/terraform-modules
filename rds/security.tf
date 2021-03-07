###################
# Security
###################

module "rds-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v3.9.0"

  name        = "${var.name}-rds-sg"
  vpc_id      = var.vpc_id
  description = "Security group for RDS instance"

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = var.allowed_security_group
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = merge(
  {
    "Name" = "${var.name}-rds-sg"
  }
  )
}



