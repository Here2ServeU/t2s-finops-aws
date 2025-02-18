variable "budget_name" {
  description = "The name of the budget"
  type        = string
}

variable "budget_threshold" {
  description = "Threshold for budget alert"
  type        = number
}

variable "time_unit" {
  description = "Time unit for budget (MONTHLY, QUARTERLY, YEARLY)"
  type        = string
}

variable "budget_type" {
  description = "Type of budget (COST, USAGE, SAVINGS_PLANS_UTILIZATION)"
  type        = string
}

variable "cost_filter" {
  description = "Filter to specify what costs to track"
  type        = map(string)
  default     = {}
}

variable "alert_email" {
  description = "Email for budget notifications"
  type        = string
}

variable "budget_limit" {
  description = "The budget threshold limit in USD"
  type        = number
}