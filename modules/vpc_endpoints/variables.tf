# /modules/vpc_endpoints/variables.tf

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
  description = "VPC ID where endpoints will be created"
  type        = string
}

variable "private_route_table_ids" {
  description = "Private route table IDs (web/app/db) for gateway endpoints"
  type        = list(string)
}
