# /modules/db_secretss/variables.tf

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
  default     = "aws"
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
