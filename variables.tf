variable "aws_region" {
  default = "us-east-1"
}

variable "backend_bucket" {
  description = "S3 bucket for storing Terraform state"
  type        = string
  default     = "t2s-finops-terraform-state"
}

variable "backend_key" {
  description = "State file path in S3"
  type        = string
  default     = "state/finops.tfstate"
}

variable "aws_region" {
  description = "AWS region for deployments"
  type        = string
  default     = "us-east-1"
}

variable "backend_encrypt" {
  description = "Enable encryption for the Terraform state file"
  type        = bool
  default     = true
}

variable "backend_dynamodb_table" {
  description = "DynamoDB table for state locking"
  type        = string
  default     = "t2s-terraform-lock"
}