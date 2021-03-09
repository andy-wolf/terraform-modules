###################
# ec2-instance.tf
###################

terraform {
  backend "s3" {}
}

// Determine correct AMI to use
data "aws_ssm_parameter" "image_id" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

// Create new EC2 instance based o this AMI image
resource "aws_instance" "ec2_instance" {
  ami = data.aws_ssm_parameter.image_id.value
  instance_type = var.instance_type

  //key_name = var.key_name
  //subnet_id = var.public_subnets[0]
  //associate_public_ip_address = true
  availability_zone = "eu-central-1a"   // TODO: Parameterize
  //security_groups = [
  //  var.security_group
  //]

  tags = {
    "Name" = var.name
  }
}

