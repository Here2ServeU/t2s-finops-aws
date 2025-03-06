aws_region = "us-east-1"
bucket_name = "t2s-cost-reports-2025"
sns_topic_arn = "arn:aws:sns:us-east-1:730335276920:FinOpsAlerts"
backend_bucket = "t2s-finops-terraform-state"
backend_key = "state/finops.tfstate"
backend_encrypt = true
backend_dynamodb_table = "t2s-terraform-lock"

