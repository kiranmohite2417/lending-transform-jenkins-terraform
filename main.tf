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
  source                 = "./modules/ec2"
  ami                    = var.ami
  instance_type          = var.instance_type
  instance_count         = var.instance_count
  key_name               = var.key_name
  private_subnet_ids     = module.vpc.private_subnet_ids
  frontend_sg_id         = module.security_groups.frontend_sg_id
  backend_sg_id          = module.security_groups.backend_sg_id
  bastion_public_subnet_id = module.vpc.public_subnet_ids[0]
  bastion_sg_id          = module.security_groups.bastion_sg_id
}

module "rds" {
  source                = "./modules/rds_instance"
  db_instance_identifier = var.db_instance_identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  db_instance_class      = var.db_instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  private_subnet_ids     = module.vpc.private_subnet_ids
  rds_sg_id              = [module.security_groups.rds_sg_id]
  db_subnet_group_name   = var.db_subnet_group_name
}

module "alb" {
  source                     = "./modules/alb"
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  alb_name                   = var.alb_name
  alb_security_group_ids     = [module.security_groups.alb_sg_id]
  frontend_target_group_name = var.frontend_target_group_name
  frontend_instances_ids     = module.ec2_instances.frontend_instances_ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
