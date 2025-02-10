output "sns_topic_arn" {
  value = aws_sns_topic.billing_alerts.arn
}