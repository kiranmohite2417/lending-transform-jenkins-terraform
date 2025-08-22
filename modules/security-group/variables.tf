variable "vpc_id" {
  description = "The VPC ID where the security groups will be created."
  type        = string
}

variable "bastion_sg_name" {
  description = "The name for the Bastion security group."
  type        = string
}

variable "bastion_sg_description" {
  description = "The description for the Bastion security group."
  type        = string
}

variable "frontend_sg_name" {
  description = "The name for the Frontend security group."
  type        = string
}

variable "frontend_sg_description" {
  description = "The description for the Frontend security group."
  type        = string
}

variable "backend_sg_name" {
  description = "The name for the Backend security group."
  type        = string
}

variable "backend_sg_description" {
  description = "The description for the Backend security group."
  type        = string
}

variable "rds_sg_name" {
  description = "The name for the RDS security group."
  type        = string
}

variable "rds_sg_description" {
  description = "The description for the RDS security group."
  type        = string
}

variable "alb_sg_name" {
  description = "The name for the ALB security group."
  type        = string
}

variable "alb_sg_description" {
  description = "The description for the ALB security group."
  type        = string
}

variable "anywhere" {
  description = "The address of internet."
  type        = list(string)
}
