# /modules/rds/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "tier" {
  type        = string
  description = "Tier tag (db)"
  default     = "db"
}

variable "db_instance_type" {
  type        = string
  description = "RDS instance class"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "Private DB subnet IDs"
}

variable "db_security_group_ids" {
  type        = list(string)
  description = "DB security group IDs"
}

variable "db_username" {
  type        = string
  description = "Master DB username"
  default = "ffd-app-db-master"
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ for primary"
  default     = false
}

variable "is_replica" {
  type        = bool
  description = "If true, create a read replica instead of a primary"
  default     = false
}

variable "primary_instance_arn" {
  type        = string
  description = "ARN of primary DB when creating a cross-region read replica"
  default     = ""
}

variable "enable" {
  type        = bool
  description = "Toggle RDS resources"
  default     = false
}
