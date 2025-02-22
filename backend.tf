terraform {
  backend "s3" {
    bucket         = "t2s-finops-terraform-state"
    key            = "state/finops.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "t2s-terraform-lock"
  }
}