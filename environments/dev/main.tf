provider "aws" {
  region = var.aws_region
}

# Backend S3 for Terraform State
module "backend" {
  source              = "../../modules/backend"
  s3_bucket_name = var.s3_bucket_name
  dynamodb_table_name = var.dynamodb_table_name
}

# SNS Topic for Cost Alerts
module "sns_alerts" {
  source        = "../../modules/sns_alerts"
  sns_topic_name = var.sns_topic_name
  alert_email   = var.alert_email
}

# AWS Budgets
module "aws_budgets" {
  source            = "../../modules/aws_budgets"
  budget_name       = var.budget_name
  budget_threshold  = var.budget_threshold
  time_unit         = var.time_unit
  budget_type       = var.budget_type
  budget_limit = var.budget_limit
  cost_filter       = var.cost_filter
  alert_email       = var.alert_email
}

# Cost Anomaly Detection
module "cost_anomaly" {
  source                  = "../../modules/cost_anomaly"
  anomaly_monitor_name    = var.anomaly_monitor_name
  anomaly_monitor_type    = var.anomaly_monitor_type
  anomaly_subscription_name = var.anomaly_subscription_name
  alert_email             = var.alert_email
}

# Cost Explorer
module "cost_explorer" {
  source     = "../../modules/cost_explorer"
  s3_region  = var.s3_region
  s3_bucket  = var.s3_bucket
  report_name = var.report_name
}

output "sns_topic_arn" {
  value = module.sns_alerts.sns_topic_arn
}
