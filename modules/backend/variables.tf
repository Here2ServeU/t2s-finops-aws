variable "s3_bucket_name" {
  description = "S3 bucket name for Terraform state storage"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
}