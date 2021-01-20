###################
# storage-gateway-instance.tf
###################

terraform {
  backend "s3" {}
}


// Determine correct AMI to use
data "aws_ssm_parameter" "image_id" {
  // E.g. aws-storage-gateway-1599010968 - ami-08254028c01ad6e2e
  name = "/aws/service/storagegateway/ami/FILE_S3/latest"
}


// Create new EC2 instance based o this AMI image
resource "aws_instance" "storage_gateway_instance" {
  ami = data.aws_ssm_parameter.image_id.value
  instance_type = var.instance_type

  //key_name = var.key_name
  //subnet_id = var.public_subnets[0]
  //associate_public_ip_address = true

  security_groups = [aws_security_group.http_from_local.id, aws_security_group.ssh_from_local.id]

  tags = {
    "Name" = var.name
  }
}


// Additional disk for caching
resource "aws_ebs_volume" "data_cache" {
  availability_zone = "eu-central-1a"   // Fixed AZ necessary !?
  size              = 50

  tags = {
    "Name" = "${var.name}-ebs-volume"
  }
}

resource "aws_volume_attachment" "data_cache" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.data_cache.id
  instance_id = aws_instance.storage_gateway_instance.id
}

// No need for a key pair???



/*
// New security group which allows NFS access on various ports from ???
// See https://docs.aws.amazon.com/storagegateway/latest/userguide/Requirements.html
1. http 80 port for file gateway activation
2. TCP 2049 for NFS, For local systems to connect to NFS shares that your gateway exposes.
3. TCP 20048 for NFSv3, For local systems to connect to mounts that your gateway exposes.
4. TCP 111 for NFSv3, For local systems to connect to the port mapper that your gateway exposes.
*/

data "http" "local_ip_address" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  local_ip_address = "${chomp(data.http.local_ip_address.body)}/32"
}

resource "aws_security_group" "ssh_from_local" {
  name        = "ssh-from-local"
  description = "Allow SSH access only from local machine"

  //vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.local_ip_address]
  }

  tags = {
    Name = "ssh-from-local"
  }
}


resource "aws_security_group" "http_from_local" {
  name        = "http-from-local"
  description = "Allow HTTP and HTTPS access only from local machine"

  //vpc_id = var.vpc_id

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
    Name = "http-from-local"
  }
}

resource "aws_security_group" "nfs_from_local" {
  name        = "nfs-from-local"
  description = "Allow SSH access only from local machine"

  //vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.local_ip_address]
  }

  tags = {
    Name = "nfs-from-local"
  }
}