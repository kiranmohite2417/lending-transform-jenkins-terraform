resource "tls_private_key" "deployer" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = tls_private_key.deployer.public_key_openssh
}

resource "local_file" "local_ssh_private_key" {
  content        = tls_private_key.deployer.private_key_pem
  filename       = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

resource "aws_instance" "frontend_instances" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.frontend_sg_id]

  tags = {
    Name = "Frontend-${count.index + 1}"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "hello frontend ${count.index + 1}" | sudo tee /var/www/html/index.html
  EOF
}

resource "aws_instance" "backend_instances" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.backend_sg_id]

  tags = {
    Name = "Backend-${count.index + 1}"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "hello backend ${count.index + 1}" | sudo tee /var/www/html/index.html
  EOF
}

resource "aws_instance" "bastion_host" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.bastion_public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]

  tags = {
    Name = "Bastion-Host"
  }
}

