# /modules/dynamodb/variables.tf

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

variable "enable_global_table" {
  type        = bool
  description = "Whether to configure this table as a global table"
  default     = false
}

variable "replica_regions" {
  type        = list(string)
  description = "Replica regions for the DynamoDB global table (prod only)"
  default     = []
}

variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
  default     = ""
}
