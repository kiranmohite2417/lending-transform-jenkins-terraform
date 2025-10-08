# Lending Platform Infrastructure – Jenkins + Terraform

This repository automates the provisioning of AWS infrastructure for a **Lending Transformation application** using **Terraform** and **Jenkins**.  
It defines modular, reusable components for networking, compute, database, and load balancing — all orchestrated through a Jenkins pipeline.

---

## 📁 Repository Structure

```
lending-transform-jenkins-terraform-main/
│
├── Jenkinsfile                # Jenkins pipeline definition
├── backend.tf                 # Terraform backend configuration (S3, DynamoDB)
├── main.tf                    # Main Terraform configuration
├── provider.tf                # AWS provider setup
├── terraform.tfvars           # Variable values for infrastructure
├── variables.tf               # Input variables for Terraform
│
└── modules/
    ├── alb/                   # Application Load Balancer module
    ├── ec2/                   # EC2 instance module
    ├── rds_instance/          # RDS (MySQL/PostgreSQL) database module
    ├── security-group/        # Security groups for networking rules
    └── vpc/                   # VPC, subnets, routing setup
```

---

## ⚙️ How It Works

1. **Terraform Modules** define each resource (VPC, EC2, ALB, RDS, Security Groups).
2. **main.tf** ties all modules together and configures their dependencies.
3. **backend.tf** stores Terraform state remotely (S3 bucket + DynamoDB for locking).
4. **provider.tf** sets up the AWS provider and region.
5. **terraform.tfvars** contains environment-specific values like instance types, VPC CIDR, etc.
6. **Jenkinsfile** automates:
   - Terraform init
   - Terraform plan
   - Terraform apply (after approval)
   - Terraform destroy (optional cleanup)

---

## 🏗️ AWS Architecture Diagram (ASCII)

```
                    +-------------------------------+
                    |         AWS Cloud             |
                    |-------------------------------|
                    |                               |
                    |   +-----------------------+   |
                    |   |      VPC (10.0.0.0/16)|   |
                    |   |-----------------------|   |
                    |   |   +----------------+  |   |
                    |   |   |   Subnets      |  |   |
                    |   |   +----------------+  |   |
                    |   |   |                |  |   |
                    |   |   |  EC2 Instances |<------------------+
                    |   |   |                |  |   |            |
                    |   |   +----------------+  |   |            |
                    |   |          ^             |   |            |
                    |   |          |             |   |            |
                    |   |   +----------------+   |   |            |
                    |   |   |   ALB (ELB)    |---+---+  Internet |
                    |   |   +----------------+   |                |
                    |   |          |             |                |
                    |   |   +----------------+   |                |
                    |   |   |  RDS Database  |   |                |
                    |   |   +----------------+   |                |
                    |   +-----------------------+                |
                    +---------------------------------------------+
```

---

## 🔄 Jenkins Pipeline Flow

```
+------------------+
|  SCM Checkout    |  <-- Pull code from GitHub
+------------------+
          |
          v
+------------------+
| Terraform Init   |  <-- Initialize backend, modules
+------------------+
          |
          v
+------------------+
| Terraform Plan   |  <-- Preview infrastructure changes
+------------------+
          |
          v
+------------------+
| Manual Approval  |  <-- Jenkins input for confirmation
+------------------+
          |
          v
+------------------+
| Terraform Apply  |  <-- Deploy infrastructure to AWS
+------------------+
          |
          v
+------------------+
| Terraform Destroy|  <-- (Optional) Cleanup resources
+------------------+
```

---

## 🏗️ AWS Resources Created

| Resource Type      | Module             | Description |
|--------------------|--------------------|--------------|
| **VPC**            | `modules/vpc`      | Creates custom VPC, subnets, route tables, and internet gateway |
| **Security Groups**| `modules/security-group` | Defines inbound/outbound rules for EC2, ALB, and RDS |
| **EC2 Instance**   | `modules/ec2`      | Creates compute resources for the application |
| **Application Load Balancer (ALB)** | `modules/alb` | Distributes traffic to EC2 instances |
| **RDS Database**   | `modules/rds_instance` | Creates an RDS instance with subnet groups |
| **IAM Roles/Policies (optional)** | Inline in modules | Used by EC2 and Jenkins pipeline to access AWS resources |

---

## 🚀 Setup & Deployment Steps

### 1. Prerequisites

- AWS CLI configured (`aws configure`)
- Terraform ≥ v1.5
- Jenkins with Terraform and AWS credentials
- S3 bucket and DynamoDB table created for remote backend

### 2. Clone the Repository
```bash
git clone https://github.com/<your-org>/lending-transform-jenkins-terraform.git
cd lending-transform-jenkins-terraform-main
```

### 3. Configure Variables
Update `terraform.tfvars` with environment-specific values:
```hcl
region          = "us-east-1"
vpc_cidr        = "10.0.0.0/16"
instance_type   = "t3.micro"
db_engine       = "mysql"
db_instance     = "db.t3.micro"
```

### 4. Initialize Terraform
```bash
terraform init
```

### 5. Validate and Plan
```bash
terraform validate
terraform plan
```

### 6. Apply Changes
```bash
terraform apply
```

### 7. Jenkins Pipeline (CI/CD)
The `Jenkinsfile` automates the above Terraform steps.  
In Jenkins:
1. Create a new pipeline job.
2. Point it to this Git repository.
3. Configure environment variables (AWS credentials, backend details).
4. Run the job — Terraform will plan, apply, and output resource info.

---

## 🧹 Cleanup

To destroy all resources:
```bash
terraform destroy
```

---

## 🔍 Notes & Best Practices

- Always review the Terraform plan before applying.
- Keep secrets (DB passwords, keys) in Jenkins credentials, not `tfvars`.
- Use different workspaces for environments: `terraform workspace new dev|staging|prod`
- Enable state locking using DynamoDB to avoid concurrent modifications.
- ALB and EC2 are public; RDS should be private within subnets.

---

## 🧭 Future Enhancements

- Add S3 + CloudFront for static assets
- Integrate monitoring with CloudWatch
- Add auto-scaling groups (ASG)
- Implement blue-green deployment strategy

---

## 📜 License
This project is licensed under the MIT License.  
See the [LICENSE](LICENSE) file for details.
