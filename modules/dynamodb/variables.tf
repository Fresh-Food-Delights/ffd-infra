# /modules/dynamodb/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
}

variable "region" {
  type        = string
  description = "Region where the table is managed"
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
