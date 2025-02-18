resource "aws_budgets_budget" "cost_alert" {
  name              = "cost-alert"
  budget_type       = "COST"
  limit_amount      = var.budget_limit
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80  # Alert when 80% of budget is reached
    notification_type   = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }
}