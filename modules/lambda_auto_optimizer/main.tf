# Create IAM Role for Lambda
resource "aws_iam_role" "lambda_finops_role" {
  name = "lambda_finops_optimizer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# IAM Policy for Lambda to stop EC2 & RDS and access CloudWatch
resource "aws_iam_policy" "lambda_finops_policy" {
  name        = "lambda_finops_policy"
  description = "Policy to allow Lambda to stop underutilized EC2 and RDS instances."
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances",
          "rds:DescribeDBInstances",
          "rds:StopDBInstance",
          "cloudwatch:GetMetricData"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach IAM Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_finops_attach" {
  policy_arn = aws_iam_policy.lambda_finops_policy.arn
  role       = aws_iam_role.lambda_finops_role.name
}

# Automatically package the Lambda function into a ZIP file
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Create Lambda Function for Cost Optimization
resource "aws_lambda_function" "finops_optimizer" {
  function_name = "finops_auto_optimizer"
  role          = aws_iam_role.lambda_finops_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 30
  filename      = data.archive_file.lambda_package.output_path

  environment {
    variables = {
      LAMBDA_AWS_REGION = var.aws_region
    }
  }
}

# Allow SNS to trigger the Lambda function
resource "aws_lambda_permission" "sns_trigger" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.finops_optimizer.arn
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}