###################
# Access from Workstation
###################
terraform {
  backend "s3" {}
}

data "http" "local_ip_address" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  local_ip_address = "${chomp(data.http.local_ip_address.body)}/32"
}

resource "aws_security_group" "ssh_from_local" {
  name        = "ssh-from-local"
  description = "Allow SSH access only from local machine"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.local_ip_address]
  }

  tags = {
    Name = "${var.name}-sg-ssh"
  }
}


resource "aws_security_group" "http_from_local" {
  name        = "http-from-local"
  description = "Allow HTTP and HTTPS access only from local machine"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.local_ip_address]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.local_ip_address]
  }

  tags = {
    Name = "${var.name}-sg-http"
  }
}
