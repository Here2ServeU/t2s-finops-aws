provider "aws" {
  region = var.aws_region
}

# Backend S3 for Terraform State
module "backend" {
  source              = "../../modules/backend"
  bucket_name         = var.bucket_name
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
  source = "../../modules/aws_budgets"
  budget_name = "T2S-Budget-Dev"
  budget_limit = 100  # Example budget limit ($100)
  sns_topic_arn = module.sns_alerts.sns_topic_arn
}

# Cost Anomaly Detection
module "cost_anomaly" {
  source = "../../modules/cost_anomaly"
  anomaly_name      = "var.anomaly_name"
  anomaly_threshold = var.anomaly_threshold
  sns_topic_arn = module.sns_alerts.sns_topic_arn
}

# Cost Explorer
module "cost_explorer" {
  source = "../../modules/cost_explorer"
  report_name = var.report_name
}

output "sns_topic_arn" {
  value = module.sns_alerts.sns_topic_arn
}