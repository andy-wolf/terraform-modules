###################
# MySQL Database
###################
terraform {
  backend "s3" {}
}

resource "aws_db_instance" "my_database" {
  allocated_storage           = var.allocated_storage
  storage_type                = var.storage_type
  engine                      = "mysql"   // TODO: Make configurable with defaults
  engine_version              = "5.7"     // TODO: Make configurable with defaults
  instance_class              = var.instance_class
  name                        = var.database_name
  username                    = var.user_name
  password                    = var.user_password
  parameter_group_name        = "default.mysql5.7"  // TODO: Make configurable with defaults
  db_subnet_group_name        = var.database_subnet_group
  vpc_security_group_ids      = [module.rds-security-group.this_security_group_id]
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  maintenance_window          = var.maintenance_window
  multi_az                    = var.multi_az
  skip_final_snapshot         = var.skip_final_snapshot
}