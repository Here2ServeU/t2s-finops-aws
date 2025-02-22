terraform {
  backend "s3" {
    bucket         = var.backend_bucket
    key            = var.backend_key
    region         = var.aws_region
    encrypt        = var.backend_encrypt
    dynamodb_table = var.backend_dynamodb_table
  }
}