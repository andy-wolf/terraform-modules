###################
# EC2
###################
terraform {
  backend "s3" {}
}

resource "aws_instance" "bastion" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"    // TODO: Remove hardcoding
  key_name = var.key_name
  subnet_id = var.public_subnets[0]
  associate_public_ip_address = true
  security_groups = [var.security_group]

  tags = merge(
  {
    "Name" = var.name
  }
  )
}

resource "aws_eip" "bastion-eip" {
  instance = aws_instance.bastion.id
  vpc = true

  tags = merge(
  {
    "Name" = var.name
  }
  )
}


