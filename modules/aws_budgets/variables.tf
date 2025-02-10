variable "budget_name" {
  description = "Name of the AWS budget"
  type        = string
}

variable "budget_limit" {
  description = "Budget limit in USD"
  type        = number
}