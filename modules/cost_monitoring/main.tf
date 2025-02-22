resource "aws_cloudwatch_metric_alarm" "cost_alarm" {
  alarm_name          = "Monthly-Spend-Limit"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace          = "AWS/Billing"
  period             = 86400
  statistic          = "Maximum"
  threshold          = var.threshold
  alarm_actions      = [var.sns_topic_arn]

  dimensions = {
    Currency = "USD"
  }
}