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

resource "aws_instance" "frontend_instances" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.frontend_sg_id]

  tags = {
    Name = "Frontend-${count.index + 1}"
  }

 user_data = <<-EOF
  #!/bin/bash
  set -euxo pipefail
  export DEBIAN_FRONTEND=noninteractive

  retry() { for i in {1..5}; do "$@" && break || { sleep $((i*5)); }; done }

  retry apt-get update -y
  retry apt-get install -y apache2

  systemctl enable --now apache2

  echo "hello frontend ${count.index + 1}" > /var/www/html/index.html

  # log everything for postmortem
  echo "USERDATA OK - frontend ${count.index + 1}" | tee -a /var/log/user-data.log
EOF

}

resource "aws_instance" "backend_instances" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.backend_sg_id]

  tags = {
    Name = "Backend-${count.index + 1}"
  }

  user_data = <<-EOF
  #!/bin/bash
  set -euxo pipefail
  export DEBIAN_FRONTEND=noninteractive

  retry() { for i in {1..5}; do "$@" && break || { sleep $((i*5)); }; done }

  retry apt-get update -y
  retry apt-get install -y apache2

  systemctl enable --now apache2

  echo "hello backend ${count.index + 1}" > /var/www/html/index.html

  # log everything for postmortem
  echo "USERDATA OK - backend ${count.index + 1}" | tee -a /var/log/user-data.log
EOF
}

resource "aws_instance" "bastion_host" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = var.bastion_public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  set -euxo pipefail

  # Put the Terraform-generated private key onto the bastion for hop SSH
  install -d -m 700 /home/ubuntu/.ssh
  cat > /home/ubuntu/.ssh/deployer.pem <<'KEY'
  ${tls_private_key.deployer.private_key_pem}
  KEY
  chown ubuntu:ubuntu /home/ubuntu/.ssh/deployer.pem
  chmod 400 /home/ubuntu/.ssh/deployer.pem

  # Optional: avoid host-key prompts when hopping
  echo -e "Host *\n  StrictHostKeyChecking no\n" >> /home/ubuntu/.ssh/config
  chown ubuntu:ubuntu /home/ubuntu/.ssh/config
  chmod 600 /home/ubuntu/.ssh/config
EOF

  tags = {
    Name = "Bastion-Host"
  }
}

