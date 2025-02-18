resource "aws_cur_report_definition" "cost_report" {
  report_name                = var.report_name
  time_unit                  = "DAILY"  
  format                     = "textORcsv"  
  compression                = "GZIP"  
  additional_schema_elements = ["RESOURCES"]  
  s3_bucket                  = var.s3_bucket  
  s3_prefix                  = "cost-reports"
  s3_region                  = var.s3_region  
}