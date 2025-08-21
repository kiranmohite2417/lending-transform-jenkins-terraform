terraform {
  backend "s3" {
    bucket         = "kiran-terraform-state-11"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "kiran-terraform-table"
  }
}
