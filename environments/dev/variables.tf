variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "sns_topic_name" {
  description = "The name of the SNS topic for cost alerts"
  type        = string
}

variable "alert_email" {
  description = "The email address for SNS alerts"
  type        = string
}

variable "email" {
  description = "The email to use for alerts"
  type = string
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

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type = string 
}

variable "lock_table_name" {
  description = "The name of the DynamoDB table for state locking"
}

variable "anomaly_monitor_type" {
  description = "Type of the cost anomaly monitor"
  type        = string
  
}

variable "budget_threshold" {
  description = "Threshold for the budget alert"
  type        = number
}

variable "time_unit" {
  description = "Time unit for the budget (DAILY, MONTHLY, QUARTERLY, ANNUALLY)"
  type        = string
  default     = "MONTHLY"
}

variable "budget_type" {
  description = "Type of budget (COST, USAGE, RI_UTILIZATION, RI_COVERAGE, SAVINGS_PLANS_UTILIZATION, SAVINGS_PLANS_COVERAGE)"
  type        = string
  default     = "COST"
}

variable "cost_filter" {
  description = "Filters for budget costs (e.g., service, linked account, etc.)"
  type        = map(string)
  default     = {}
}

variable "anomaly_monitor_name" {
  description = "Name of the anomaly monitor"
  type        = string
}

variable "anomaly_subscription_name" {
  description = "Name of the anomaly subscription"
  type        = string
}

variable "s3_region" {
  description = "Region of the S3 bucket used for Cost Explorer reports"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket name for Cost Explorer reports"
  type        = string
}