module "budget" {
  source           = "../../modules/budget"
  budget_name      = "FinOps Budget Dev"
  limit_amount     = "1000"
  subscriber_emails = ["finops-dev@example.com"]
}

module "cost_monitoring" {
  source         = "../../modules/cost_monitoring"
  threshold      = "500"
  sns_topic_arn  = "arn:aws:sns:us-east-1:123456789012:FinOpsAlerts"
}

module "security" {
  source = "../../modules/security"
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "t2s-finops-dev-reports"
}

module "lambda_auto_optimizer" {
  source       = "../../modules/lambda_auto_optimizer"
  aws_region   = var.aws_region
  sns_topic_arn = var.sns_topic_arn
}