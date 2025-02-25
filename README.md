# T2S FinOps Infrastructure on AWS with Terraform

This repository provisions a **FinOps infrastructure on AWS** using **Terraform modules and environments** (`dev`, `stage`, `prod`). 

It includes **budget monitoring, cost anomaly detection, automatic cost optimization, security logging, and storage**.

---

## Features
- **AWS Budgets** to track and control spending.
- **Cost Anomaly Detection** to identify unexpected costs.
- **CloudWatch Alarms** for real-time cost monitoring.
- **GuardDuty** for security insights.
- **S3** for FinOps cost reports.
- **Lambda Auto Optimizer** (Stops underutilized EC2 & RDS when cost anomalies occur).
- **Terraform modules & environments** for scalable infrastructure.

---

## **Project Structure**
```plaintext
T2S-FINOPS-AWS/
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│   │   ├── versions.tf
│   ├── prod/
│   ├── stage/
├── modules/
│   ├── backend/
│   ├── budget/
│   ├── cost_monitoring/
│   ├── lambda_auto_optimizer/
│   ├── s3/
│   ├── security/
└── README.md
```

---
## Prerequisites

Before deploying, ensure you have:
- Terraform installed (>= 1.5.0)
- AWS CLI configured (aws configure)
- S3 bucket & DynamoDB table for Terraform state management
- An AWS SNS Topic for cost anomaly alerts

---

### Part 1: Introduction to FinOps & Terraform Project Setup

[![Watch the Video](https://img.youtube.com/vi/4HqoyhZWYp0/0.jpg)](https://youtu.be/4HqoyhZWYp0?si=tHogCDbtLA4OAQWV)

---
## Step 1: Backend (State Management)

- Go to /modules/backend/ directory. 
- Edit the **terraform.tfvars** in the /modules/backend/ directory, and set backend parameters:
```hcl
s3_bucket_name       = "t2s-finops-terraform-state"  # Replace with the desired S3 Bucket name. 
dynamodb_table_name  = "t2s-terraform-lock"           # Replace with the desired DynamoDB Table.
```

- Run the following command to initialize the backend:
```bash
terraform init 
terraform validate
terraform apply -auto-approve
```

## Step 2: Configure Variables in the environments/dev/ directory

- Modify **terraform.tfvars** inside environments/dev/:
```hcl
aws_region       = "us-east-1"
sns_topic_arn    = "arn:aws:sns:us-east-1:123456789012:FinOpsAlerts"
bucket_name      = "t2s-finops-reports"
```

- Modify the **backend.tf** with the desired backend parameters: 
```hcl
   bucket         = "t2s-finops-terraform-state"
    key            = "state/finops.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "t2s-terraform-lock"
```

**Note**: You will not need to hardcode these parameters, but use a **backend.tfvars** file for this. 

## Step 3: Deploy the Infrastructure

Run the following commands inside environments/dev/:
```
cd environments/dev
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars" -auto-approve
```

## Step 4: Verify Resources

After deployment, check if resources were created:
```bash
aws budgets describe-budgets --account-id 123456789012   # Replace with correct AWS Account ID
aws cloudwatch describe-alarms
aws lambda list-functions | grep finops_auto_optimizer
aws s3 ls | grep finops
```

## Step 5: Deploy to Other Environments as Desired

To deploy in stage or prod, switch to the respective directory:

cd environments/stage
terraform apply -var-file="terraform.tfvars" -auto-approve

cd environments/prod
terraform apply -var-file="terraform.tfvars" -auto-approve

## Step 6: Destroy the Infrastructure

- To remove resources:
```bash
terraform destroy -var-file="terraform.tfvars" -auto-approve
```

- If S3 bucket deletion fails, manually empty it before re-running Terraform:
```bash
aws s3 rm s3://t2s-finops-terraform-state --recursive
```

- For versioned buckets:
```bash
aws s3api list-object-versions --bucket t2s-finops-terraform-state \
  --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}' \
  --output json | \
  jq -c '.Objects[]' | \
  while read obj; do
    key=$(echo $obj | jq -r '.Key')
    versionId=$(echo $obj | jq -r '.VersionId')
    aws s3api delete-object --bucket t2s-finops-terraform-state --key "$key" --version-id "$versionId"
  done
```

---

## Troubleshooting

### Issue: Lambda ZIP File Not Found

#### Error:

**Error:** reading ZIP file (lambda_function.zip): no such file or directory

**Fix:**
- Ensure the function is correctly zipped:
```bash
cd modules/lambda_auto_optimizer/
zip lambda_function.zip lambda_function.py
```
- Then, rerun:
```bash
terraform apply -var-file="terraform.tfvars" -auto-approve
```

**Issue:** AWS_REGION Reserved Key Error

**Error:**
```plaintext
InvalidParameterValueException: Lambda was unable to configure your environment variables.
```

**Fix:**
- Modify lambda_function.py to use LAMBDA_AWS_REGION instead of AWS_REGION:
```py
import os
AWS_REGION = os.getenv("LAMBDA_AWS_REGION")
```

- Update main.tf in lambda_auto_optimizer:
```py
environment {
  variables = {
    LAMBDA_AWS_REGION = var.aws_region
  }
}
```

- Redeploy:
```bash
terraform apply -var-file="terraform.tfvars" -auto-approve
```

**Issue:** SNS Topic ARN Prompting for Input

**Error:**
```bash
var.sns_topic_arn
  Enter a value:
```

**Fix:**
- Ensure terraform.tfvars has:
```hcl
sns_topic_arn = "arn:aws:sns:us-east-1:123456789012:FinOpsAlerts"
```

- And pass it explicitly:
```bash
terraform apply -var-file="terraform.tfvars" -auto-approve
```

---

### Key Takeaways
- **Modular Terraform** Structure for FinOps scalability.
- **Cost Optimization** via **AWS Budgets & CloudWatch Alarms**.
- **Lambda** Auto Optimizer reduces cloud waste automatically.
- **GuardDuty** Integration for enhanced security.
- **S3** Reports Storage for cost analysis.

**Happy FinOps Optimization!**

---

### **🚀 Why This README is Effective**
- **Step-by-step deployment guide**  
- **Common errors & solutions for troubleshooting**  
- **Scalable Terraform structure for multi-environment deployment**  
- **Clearly documents purpose & resources used**  
