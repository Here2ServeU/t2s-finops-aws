variable "report_name" {
  description = "Name of the Cost and Usage Report"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket name to store cost reports"
  type        = string
}

variable "s3_region" {
  description = "AWS Region of the S3 bucket"
  type        = string
}