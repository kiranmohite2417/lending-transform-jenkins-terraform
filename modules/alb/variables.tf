variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "alb_name" { type = string }
variable "alb_security_group_ids" { type = list(string) }
variable "frontend_target_group_name" { type = string }
variable "frontend_instances_ids" { type = list(string) }
