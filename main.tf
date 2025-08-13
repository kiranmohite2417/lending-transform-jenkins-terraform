module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones
}

module "security_groups" {
  source                  = "./modules/security-group"
  vpc_id                  = module.vpc.vpc_id
  bastion_sg_name         = var.bastion_sg_name
  bastion_sg_description  = var.bastion_sg_description
  frontend_sg_name        = var.frontend_sg_name
  frontend_sg_description = var.frontend_sg_description
  backend_sg_name         = var.backend_sg_name
  backend_sg_description  = var.backend_sg_description
  rds_sg_name             = var.rds_sg_name
  rds_sg_description      = var.rds_sg_description
  alb_sg_name             = var.alb_sg_name
  alb_sg_description      = var.alb_sg_description
  anywhere                = var.anywhere
}

module "ec2_instances" {
  source                   = "./modules/ec2"
  ami                      = var.ami
  instance_type            = var.instance_type
  instance_count           = var.instance_count
  availability_zones       = var.availability_zones
  key_name                 = var.key_name
  private_subnet_ids       = module.vpc.private_subnet_ids
  public_subnet_ids        = module.vpc.public_subnet_ids
  bastion_public_subnet_id = module.vpc.public_subnet_ids[0]
  frontend_sg_id           = module.security_groups.frontend_sg_id
  backend_sg_id            = module.security_groups.backend_sg_id
  bastion_sg_id            = module.security_groups.bastion_sg_id
}

module "rds_instance" {
  source                 = "./modules/rds_instance"
  engine                 = var.engine
  engine_version         = var.engine_version
  db_name                = var.db_name
  db_instance_identifier = var.db_instance_identifier
  db_subnet_group_name   = var.db_subnet_group_name
  parameter_group_name   = var.parameter_group_name
  db_instance_class      = var.db_instance_class
  allocated_storage      = var.allocated_storage
  username               = var.username
  password               = var.password
  rds_sg_id              = [module.security_groups.rds_sg_id]
  private_subnet_ids     = module.vpc.private_subnet_ids
}

module "alb" {
  source                     = "./modules/alb"
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  alb_name                   = var.alb_name
  alb_security_group_ids     = [module.security_groups.alb_sg_id]
}

