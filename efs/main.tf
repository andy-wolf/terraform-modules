###################
# EFS
###################
terraform {
  backend "s3" {}
}

resource "aws_efs_file_system" "foo" {

  tags = merge(
  {
    "Name" = var.name
  }
  )
}

resource "aws_efs_mount_target" "mount" {
  count = length(var.private_subnet_ids)
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      = element(var.private_subnet_ids, count.index)
  security_groups = [module.efs_sg.this_security_group_id]
}

