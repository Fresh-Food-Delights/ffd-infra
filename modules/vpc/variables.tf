# /modules/vpc/variables.tf

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

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
