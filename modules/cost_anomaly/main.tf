resource "aws_ce_anomaly_monitor" "cost_anomaly" {
  name         = var.anomaly_monitor_name
  monitor_type = var.anomaly_monitor_type  # ✅ Ensure this is defined
}

resource "aws_ce_anomaly_subscription" "cost_subscription" {
  name          = var.anomaly_subscription_name
  frequency     = "DAILY"
  monitor_arn_list = [aws_ce_anomaly_monitor.cost_anomaly.arn]  # ✅ FIXED ARGUMENT
  subscriber {
    type    = "EMAIL"
    address = var.alert_email
  }
}

resource "aws_ce_anomaly_detection" "cost_anomaly" {
  name                  = var.anomaly_monitor_name
  monitor_type          = "DIMENSIONAL"
  monitor_dimension     = "SERVICE"
  monitor_specification = jsonencode({ Service = "Amazon EC2" })
}
