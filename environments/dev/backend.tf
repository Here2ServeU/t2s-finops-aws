terraform {
  backend "s3" {
    bucket         = "t2s-finops-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "t2s-finops-terraform-locks"
  }
}