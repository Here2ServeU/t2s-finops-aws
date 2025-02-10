resource "aws_budgets_budget" "t2s_budget" {
  name              = var.budget_name
  budget_type       = "COST"
  limit_amount      = var.budget_limit
  limit_unit        = "USD"
  time_period_start = "2025-01-01_00:00"
  time_period_end   = "2025-12-31_23:59"
}