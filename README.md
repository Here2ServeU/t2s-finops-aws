# AWS FinOps Infrastructure with Terraform

This repository provisions a **FinOps infrastructure on AWS** using **Terraform modules and environments** (`dev`, `stage`, `prod`). It includes **budget monitoring, cost anomaly detection, automatic cost optimization, security logging, and storage**.

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
finops-infra/
├── modules/
│   ├── budget/
│   ├── cost_monitoring/
│   ├── cost_anomaly_detection/
│   ├── security/
│   ├── s3/
│   ├── lambda_auto_optimizer/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── lambda_function.py
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   ├── stage/
│   ├── prod/
├── backend.tf
├── provider.tf
└── versions.tf

---

## Step One: Set Up Backend Remote
- cd 