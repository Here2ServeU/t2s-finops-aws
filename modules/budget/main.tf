resource "aws_budgets_budget" "finops_budget" {
  name              = var.budget_name
  budget_type       = "COST"
  limit_amount      = var.limit_amount
  limit_unit        = "USD"

  # Set start time as today in the correct format (YYYY-MM-DD_HH:MM)
  time_period_start = formatdate("YYYY-MM-DD_HH:mm", timestamp())

  # Set end time as 5 years from now (AWS Budgets requires a future end time)
  time_period_end   = formatdate("YYYY-MM-DD_HH:mm", timeadd(timestamp(), "43800h")) # 5 years from now

  time_unit         = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = var.subscriber_emails
  }
}