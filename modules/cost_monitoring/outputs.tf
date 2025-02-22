output "alarm_arn" {
  value = aws_cloudwatch_metric_alarm.cost_alarm.arn
}