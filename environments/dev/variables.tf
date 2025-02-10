variable "sns_topic_name" {
  description = "The name of the SNS topic for cost alerts"
  type        = string
}

variable "alert_email" {
  description = "The email address for SNS alerts"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, stage, prod)"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table for state locking"
  type        = string
}

variable "anomaly_threshold" {
  description = "Threshold for cost anomaly detection"
  type        = number
}

variable "budget_name" {
  description = "AWS budget name"
  type        = string
}

variable "anomaly_name" {
  description = "Name of the cost anomaly detection"
  type        = string
  
}

variable "report_name" {
  description = "Name of the AWS Cost and Usage Report"
  type        = string
}

variable "budget_limit" {
  description = "Limit for the AWS budget alert"
  type        = number
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN for cost anomaly alerts"
  type        = string
}