resource "aws_s3_bucket" "cost_reports" {
  bucket = var.bucket_name
}