variable "aws_region" {
    description = "value of the region"
    type = string
}
variable "bucket_name" {
    description = "name of the bucket name"
    type = string
}
variable "sns_topic_arn" {
    description = "The sns topic arn"
    type = string
}
variable "backend_bucket" {
  description = "S3 bucket for storing Terraform state"
  type        = string
}

variable "backend_key" {
  description = "State file path in S3"
  type        = string
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