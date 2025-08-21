resource "tls_private_key" "deployer" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = tls_private_key.deployer.public_key_openssh
}

resource "local_file" "local_ssh_private_key" {
  content         = tls_private_key.deployer.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

# Simple user data for frontend: install and run nginx with health page
locals {
  user_data_frontend = <<-EOT
    #!/bin/bash
    yum update -y
    amazon-linux-extras install -y nginx1
    echo "OK" > /usr/share/nginx/html/health
    systemctl enable nginx
    systemctl start nginx
  EOT
}

resource "aws_instance" "frontend_instances" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  subnet_id                   = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids      = [var.frontend_sg_id]
  associate_public_ip_address = false
  user_data                   = local.user_data_frontend

  tags = { Name = "frontend-${count.index + 1}" }
}

resource "aws_instance" "backend_instances" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  subnet_id                   = var.private_subnet_ids[(count.index + 1) % length(var.private_subnet_ids)]
  vpc_security_group_ids      = [var.backend_sg_id]
  associate_public_ip_address = false

  tags = { Name = "backend-${count.index + 1}" }
}

resource "aws_instance" "bastion_host" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = var.bastion_public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  associate_public_ip_address = true

  tags = { Name = "bastion-host" }
}
