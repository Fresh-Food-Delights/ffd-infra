# /modules/iam/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_iam_role" "web_instance_role" {
  name = "ffd-${var.environment}-web-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
  }
}

resource "aws_iam_policy" "web_instance_policy" {
  name = "ffd-${var.environment}-web-ec2-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.web_bucket_arn,
          "${var.web_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = var.session_table_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "web_instance_attach" {
  role       = aws_iam_role.web_instance_role.name
  policy_arn = aws_iam_policy.web_instance_policy.arn
}

resource "aws_iam_instance_profile" "web_instance_profile" {
  name = "ffd-${var.environment}-web-ec2-profile"
  role = aws_iam_role.web_instance_role.name
}

resource "aws_iam_role" "app_instance_role" {
  name = "ffd-${var.environment}-app-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
  }
}

resource "aws_iam_policy" "app_instance_policy" {
  name = "ffd-${var.environment}-app-ec2-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.web_bucket_arn,
          "${var.web_bucket_arn}/*",
          var.app_bucket_arn,
          "${var.app_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = var.session_table_arn
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secretsmanager_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_instance_attach" {
  role       = aws_iam_role.app_instance_role.name
  policy_arn = aws_iam_policy.app_instance_policy.arn
}

resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "ffd-${var.environment}-app-ec2-profile"
  role = aws_iam_role.app_instance_role.name
}

resource "aws_iam_role_policy_attachment" "web_ssm" {
  count      = var.enable_ssm ? 1 : 0
  role       = aws_iam_role.web_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "app_ssm" {
  count      = var.enable_ssm ? 1 : 0
  role       = aws_iam_role.app_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_group" "it_admin_group" {
  name = "ffd-${var.environment}-aws-it-admin-${var.account_id}"
}

resource "aws_iam_group" "it_ops_group" {
  name = "ffd-${var.environment}-aws-it-ops-${var.account_id}"
}

resource "aws_iam_group_policy_attachment" "it_admin_admin_access" {
  group      = aws_iam_group.it_admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "it_ops_readonly_access" {
  group      = aws_iam_group.it_ops_group.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
