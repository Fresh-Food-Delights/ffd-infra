# /modules/db_secretss/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
}

variable "region" {
  type        = string
  description = "AWS region for this environment"
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
