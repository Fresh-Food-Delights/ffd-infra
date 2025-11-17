# modules/ssm/variables.tf

variable "environment" {
  description = "Environment name (dev/test/prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach endpoints to"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for the VPC endpoints"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}
