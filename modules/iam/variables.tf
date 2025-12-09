# /modules/iam/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
  default = "dev"
}

variable "region" {
  description = "AWS region (e.g., us-east-1)"
  type        = string
  default = "us-east-1"
}

variable "tier" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "iam"
}

variable "account_id" {
  type        = string
  description = "AWS account ID used in IAM naming"
}

variable "web_bucket_arn" {
  type        = string
  description = "ARN of the S3 web data bucket"
}

variable "app_bucket_arn" {
  type        = string
  description = "ARN of the S3 app data bucket"
}

variable "session_table_arn" {
  type        = string
  description = "ARN of the DynamoDB session table"
}

variable "secretsmanager_arn" {
  type        = string
  description = "ARN or ARN prefix of Secrets Manager secret for DB creds"
}
