# /modules/iam/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_iam_group" "it_admin_group" {
  name = "ffd-aws-it-admin-${var.environment}-7714022395766"
}

resource "aws_iam_group" "it_ops_group" {
  name = "ffd-aws-it-ops-${var.environment}-7714022395766"
}

# Admin group: full admin access
resource "aws_iam_group_policy_attachment" "it_admin_admin_access" {
  group      = aws_iam_group.it_admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Ops group: read-only access
resource "aws_iam_group_policy_attachment" "it_ops_readonly_access" {
  group      = aws_iam_group.it_ops_group.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
