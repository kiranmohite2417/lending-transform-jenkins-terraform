region                       = "ap-south-1"
vpc_cidr                     = "10.0.0.0/16"
public_subnets_cidr          = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr         = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]   # FIXED
availability_zones           = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]  # FIXED

bastion_sg_name              = "bastion-sg"
bastion_sg_description       = "Security group for Bastion Host with SSH access"
frontend_sg_name             = "frontend-sg"
frontend_sg_description      = "Security group for Frontend instances"
backend_sg_name              = "backend-sg"
backend_sg_description       = "Security group for Backend instances"
rds_sg_name                  = "rds-sg"
rds_sg_description           = "Security group for RDS cluster"
alb_sg_name                  = "alb-sg"
alb_sg_description           = "Security group for the ALB with HTTP access"
anywhere                     = ["0.0.0.0/0"]

ami                          = "ami-0f918f7e67a3323f0"
instance_type                = "t2.micro"
instance_count               = 2
key_name                     = "deployer"

db_instance_identifier       = "lentra-rds-instance"
engine                       = "mysql"
engine_version               = "8.0.42"
db_subnet_group_name         = "lentra-db-subnet-group"
parameter_group_name         = "default.mysql8.0"
db_instance_class            = "db.t3.medium"
allocated_storage            = 20
db_name                      = "lentradb"
username                     = "admin"
password                     = "Admin#2417"

alb_name                     = "lentra-application-load-balancer"
frontend_target_group_name   = "frontend-tg"
