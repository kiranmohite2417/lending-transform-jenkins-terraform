variable "ami" { type = string }
variable "instance_type" { type = string }
variable "instance_count" { type = number }
variable "key_name" { type = string }

variable "private_subnet_ids" {
  description = "Private subnet IDs for app instances"
  type        = list(string)
}

variable "frontend_sg_id" { type = string }
variable "backend_sg_id" { type = string }

variable "bastion_public_subnet_id" {
  description = "Public subnet ID for the bastion host"
  type        = string
}

variable "bastion_sg_id" {
  description = "The security group ID for the bastion host."
  type        = string
}
