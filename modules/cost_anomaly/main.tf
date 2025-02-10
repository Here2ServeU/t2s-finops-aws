resource "aws_ce_anomaly_detection" "cost_anomaly" {
  name       = var.anomaly_name
  threshold  = var.anomaly_threshold
}