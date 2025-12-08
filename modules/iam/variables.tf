# /modules/iam/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
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