# T2S Services - FinOps Infrastructure Automation with Terraform

## Introduction

As organizations scale their cloud operations, managing cloud costs effectively becomes critical. **FinOps (Financial Operations)** provides a framework to optimize cloud spending while maintaining agility and performance. This project automates **FinOps infrastructure** for **T2S Services** using **Terraform**, ensuring consistency across **development (dev), staging (stage), and production (prod) environments**.

This infrastructure will:
- **Track and optimize AWS costs** using **AWS Budgets, Cost Anomaly Detection, and Cost Explorer**.
- **Enable automated alerts** for cost anomalies via **Amazon SNS notifications**.
- **Enforce best practices for cost governance** using **Infrastructure as Code (IaC)** with Terraform.
- **Store state files securely** in an **S3 bucket** with **DynamoDB locking** for team collaboration.

By implementing this **modular Terraform** setup, T2S Services ensures **cost efficiency, scalability, and governance** across all cloud environments.

---
## Project Structure
```txt
t2s-finops/
│── modules/
│   ├── backend/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   ├── sns_alerts/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── aws_budgets/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── cost_anomaly/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── cost_explorer/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   ├── backend.tf
│   │   ├── providers.tf
│   │   ├── versions.tf
│   ├── stage/
│   │   ├── (same files as dev/)
│   ├── prod/
│   │   ├── (same files as dev/)
│── README.md
```

---
## Backend Module (S3 & DynamoDB Lock)

### modules/backend/main.tf
```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = var.s3_bucket_name
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

### modules/backend/variables.tf
```hcl
variable "s3_bucket_name" {
  description = "S3 bucket name for Terraform state storage"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
}

📄 modules/backend/outputs.tf

output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
```

### modules/backend/terraform.tfvars
```hcl
s3_bucket_name       = "t2s-finops-terraform-state"
dynamodb_table_name  = "t2s-finops-terraform-locks"
```

## SNS Alerts for Billing

### modules/sns_alerts/main.tf
```hcl
resource "aws_sns_topic" "billing_alerts" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.billing_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
```

### modules/sns_alerts/variables.tf
```hcl
variable "sns_topic_name" {
  description = "Name of the SNS topic for billing alerts"
  type        = string
}

variable "alert_email" {
  description = "Email address to receive billing alerts"
  type        = string
}
```

### modules/sns_alerts/outputs.tf
```hcl
output "sns_topic_arn" {
  value = aws_sns_topic.billing_alerts.arn
}
```

## AWS Budgets Module
### modules/aws_budgets/main.tf
```hcl
resource "aws_budgets_budget" "t2s_budget" {
  name              = var.budget_name
  budget_type       = "COST"
  limit_amount      = var.budget_limit
  limit_unit        = "USD"
  time_period_start = "2024-01-01_00:00"
  time_period_end   = "2024-12-31_23:59"
}
```

### modules/aws_budgets/variables.tf
```hcl
variable "budget_name" {
  description = "Name of the AWS budget"
  type        = string
}

variable "budget_limit" {
  description = "Budget limit in USD"
  type        = number
}
```hcl

### modules/aws_budgets/outputs.tf
```hcl
output "budget_id" {
  value = aws_budgets_budget.t2s_budget.id
}
```hcl

## Cost Anomaly Detection
### modules/cost_anomaly/main.tf
```hcl
resource "aws_ce_anomaly_detection" "cost_anomaly" {
  name       = var.anomaly_name
  threshold  = var.anomaly_threshold
}
```

### modules/cost_anomaly/variables.tf
```hcl
variable "anomaly_name" {
  description = "Name of the cost anomaly detection"
  type        = string
}

variable "anomaly_threshold" {
  description = "Threshold for anomaly detection"
  type        = number
}
```

### modules/cost_anomaly/outputs.tf
```hcl
output "anomaly_id" {
  value = aws_ce_anomaly_detection.cost_anomaly.id
}
```

## Create a Cost Explorer Module

### modules/cost_explorer/main.tf
```hcl
resource "aws_cur_report_definition" "cost_report" {
  report_name = var.report_name
}
```

### modules/cost_explorer/variables.tf
```hcl
variable "report_name" {
  description = "Name of the Cost Explorer report"
  type        = string
}
```

### modules/cost_explorer/outputs.tf
```hcl
output "cost_explorer_id" {
  value = aws_cur_report_definition.cost_report.id
}
```

## Create Environment-Specific Configurations

#### Each environment (dev, stage, prod) contains:
- backend.tf: Backend state configuration
- providers.tf: Provider settings
- versions.tf: Terraform version constraints
- terraform.tfvars: Environment-specific variables

### environments/dev/backend.tf
```hcl
terraform {
  backend "s3" {
    bucket         = "t2s-finops-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "t2s-finops-terraform-locks"
  }
}
```
### environments/dev/providers.tf
```hcl
provider "aws" {
  region = "us-east-1"
}
```

### environments/dev/versions.tf
```hcl
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}
```
### environments/dev/terraform.tfvars
```hcl
budget_name        = "T2S-Dev-Budget"
budget_limit       = 1000
anomaly_name       = "T2S-Dev-Cost-Anomaly"
anomaly_threshold  = 500
report_name        = "T2S-Dev-Cost-Report"
sns_topic_name     = "T2S-Dev-Billing-Alerts"
alert_email        = "info@transformed2succeed.com"
```

---
## Cleanup Steps
To remove the deployed FinOps infrastructure, follow these steps:

#### Destroy Resources for Each Environment
- Navigate to the environment directory (e.g., dev, stage, prod) and run:
```bash
cd environments/dev
terraform destroy -auto-approve
cd ../stage
terraform destroy -auto-approve
cd ../prod
terraform destroy -auto-approve
```
#### Destroy the Backend State Infrastructure
- Since the backend (S3 bucket and DynamoDB table) is persistent, delete it separately:
```bash
cd modules/backend
terraform destroy -auto-approve
```
#### Verify and Delete Remaining AWS Resources
Check for any orphaned resources in the AWS Console:
- Navigate to **Billing Dashboard** → Verify no active **AWS Budgets** or **Cost Anomaly Detectors**.
- Check **SNS Topics** and manually delete them if required.
- Review **S3 buckets** and **DynamoDB tables** for lingering state files.

#### Remove Local Terraform Files
Once everything is deleted, clean up local Terraform state files:
```bash
rm -rf .terraform terraform.tfstate*
```

---
## Conclusion

This **Terraform-based FinOps automation** enables **T2S Services** to:
- **Track and optimize cloud costs** with automated cost management tools.
- **Receive alerts** for unexpected spending spikes via **SNS notifications**.
- **Enforce governance and transparency** across **AWS environments**.
- **Securely store Terraform state files** using an **S3 backend with DynamoDB locks**.

By leveraging **AWS Budgets, Cost Explorer, SNS, and Terraform**, T2S Services gains **real-time insights, control, and automation** to optimize cloud expenses while ensuring **operational efficiency**.
