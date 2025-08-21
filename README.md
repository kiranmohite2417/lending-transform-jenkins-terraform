# Lending Transform Jenkins Terraform (Fixed)
This version fixes missing code, invalid ellipses, and networking required for:
- Bastion SSH to private instances
- ALB -> frontend in private subnets
- Backend reachable from frontend
- RDS reachable from backend

See variables in `terraform.tfvars`.
