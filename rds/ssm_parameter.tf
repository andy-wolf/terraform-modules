###################
# MySQL-related SSM Parameter Store information
###################
# e.g. database URL, User and Password
#


resource "aws_ssm_parameter" "database_url" {
  name = "/${var.environment}/database/${aws_db_instance.my_database.name}/url"
  type = "String"
  value = "jdbc:mysql://${aws_db_instance.my_database.endpoint}/${aws_db_instance.my_database.name}?useSSL=false&serverTimezone=UTC"

  tags = {
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "database_user_name" {
  name = "/${var.environment}/database/${aws_db_instance.my_database.name}/admin_user_name"
  type = "String"
  value = aws_db_instance.my_database.username

  tags = {
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "database_user_password" {
  name = "/${var.environment}/database/${aws_db_instance.my_database.name}/admin_user_password"
  type = "SecureString"
  value = aws_db_instance.my_database.password

  tags = {
    environment = "${var.environment}"
  }
}




