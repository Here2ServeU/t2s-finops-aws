variable "anomaly_monitor_name" {
  description = "Anomaly Monitor Name"
  type        = string
}

variable "anomaly_monitor_type" {
  description = "Type of anomaly monitor (e.g., DIMENSIONAL, SERVICE, LINKED_ACCOUNT)"
  type        = string
}

variable "anomaly_subscription_name" {
  description = "Anomaly Subscription Name"
  type        = string
}

variable "alert_email" {
  description = "Email for anomaly detection notifications"
  type        = string
}