###################
# Bastion Host
###################
terraform {
  backend "s3" {}
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_key_pair" "openvpn" {
  key_name   = var.ssh_private_key_file
  public_key = file(var.ssh_public_key_file)
}

resource "aws_instance" "openvpn" {
  ami                         = data.aws_ami.amazon_linux_2.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.openvpn.key_name
  subnet_id                   = var.public_subnets[0]

  vpc_security_group_ids = [
    aws_security_group.openvpn.id,
    var.ssh_security_group_id,
  ]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.instance_root_block_device_volume_size
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              curl -O "${var.openvpn_install_script_location}"
              chmod +x ./openvpn-install.sh

              sudo AUTO_INSTALL=y \
                APPROVE_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4) \
                ENDPOINT=$(curl http://169.254.169.254/latest/meta-data/public-hostname) \
                ./openvpn-install.sh

              sudo MENU_OPTION="1" \
                CLIENT="openvpn" \
                PASS="1" \
                SUDO_USER=ec2-user \
                ./openvpn-install.sh

              EOF

  tags = {
    Name        = var.tag_name
    Provisioner = "Terraform"
  }
}

/*
resource "null_resource" "openvpn_download_configurations" {
  depends_on = [null_resource.openvpn_update_users_script]

  triggers = {
    ovpn_users = join(" ", var.ovpn_users)
  }

  provisioner "local-exec" {
    command = <<EOT
    mkdir -p ${var.ovpn_config_directory};
    scp -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -i ${var.ssh_private_key_file} ${var.ec2_username}@${aws_instance.openvpn.public_ip}:/home/${var.ec2_username}/*.ovpn ${var.ovpn_config_directory}/

EOT

  }
}
*/