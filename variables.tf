variable "region" {
  description = "The AWS region to use for resources"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets_cidr" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones in the region"
  type        = list(string)
}

variable "anywhere" {
  description = "CIDR for internet anywhere"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Security group labels
variable "bastion_sg_name" {
  type = string
}

variable "bastion_sg_description" {
  type = string
}

variable "frontend_sg_name" {
  type = string
}

variable "frontend_sg_description" {
  type = string
}

variable "backend_sg_name" {
  type = string
}

variable "backend_sg_description" {
  type = string
}

variable "rds_sg_name" {
  type = string
}

variable "rds_sg_description" {
  type = string
}

variable "alb_sg_name" {
  type = string
}

variable "alb_sg_description" {
  type = string
}

# EC2
variable "ami" {
  description = "AMI for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "instance_count" {
  description = "Number of frontend/backend instances"
  type        = number
}

variable "key_name" {
  description = "Key name for EC2"
  type        = string
}

# RDS
variable "db_instance_identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "parameter_group_name" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

# ALB
variable "alb_name" {
  type = string
}

variable "frontend_target_group_name" {
  type = string
}

