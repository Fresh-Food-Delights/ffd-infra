# modules/iam/main.tf

# 1. IAM Role that EC2 instances will assume
resource "aws_iam_role" "app_service_role" {
  name = "${var.project_prefix}-app-service-role-${var.environment}"

  # Zero Trust principle: only EC2 can assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 2. Basic read-only policy for S3 and DynamoDB (to be refined later)
resource "aws_iam_policy" "read_access_policy" {
  name        = "${var.project_prefix}-read-access-policy-${var.environment}"
  description = "Provides read access to essential application resources."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ReadS3Objects"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*" # TODO: replace * with specific S3 bucket ARNs later
      },
      {
        Sid    = "ReadDynamoDBItems"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = "*" # TODO: replace * with specific DynamoDB table ARNs later
      }
    ]
  })
}

# 3. Attach the policy to the role
resource "aws_iam_role_policy_attachment" "read_access_attachment" {
  role       = aws_iam_role.app_service_role.name
  policy_arn = aws_iam_policy.read_access_policy.arn
}
