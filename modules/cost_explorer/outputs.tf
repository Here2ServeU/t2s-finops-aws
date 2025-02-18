output "cost_explorer_id" {
  value = aws_cur_report_definition.cost_report.id
}

output "cost_report_s3_bucket" {
  value = aws_cur_report_definition.cost_report.s3_bucket
}

output "cost_report_name" {
  value = aws_cur_report_definition.cost_report.report_name
}