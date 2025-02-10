variable "sns_topic_name" {
  description = "Name of the SNS topic for billing alerts"
  type        = string
}

variable "alert_email" {
  description = "Email address to receive billing alerts"
  type        = string
}