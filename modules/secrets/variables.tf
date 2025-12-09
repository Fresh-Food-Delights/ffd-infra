# /modules/secrets/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
  default     = "dev"
}

variable "region" {
  description = "AWS region (e.g., us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "tier" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "aws"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where Secrets Manager VPC endpoint will live"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs (typically app tier) for the Secrets Manager interface endpoint"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach to the Secrets Manager VPC endpoint"
}

variable "db_username" {
  type        = string
  description = "Database username stored in Secrets Manager"
}

variable "secret_name" {
  type        = string
  description = "Optional explicit secret name override"
  default     = ""
}

variable "enable_rds" {
  type        = bool
  description = "If true, create Secrets Manager VPC endpoint alongside the DB secret"
  default     = false
}
