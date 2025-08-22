resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "aws_db_instance" "default" {
  identifier              = var.db_instance_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  parameter_group_name    = var.parameter_group_name
  db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name   # FIXED
  vpc_security_group_ids  = var.rds_sg_id
  multi_az                = true
  storage_encrypted       = true
  skip_final_snapshot     = true
}
