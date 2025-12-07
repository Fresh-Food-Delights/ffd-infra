# /modules/ssm/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
}

variable "region" {
  type        = string
  description = "AWS region for the SSM VPC endpoints"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the SSM VPC endpoints will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the SSM interface endpoints"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs applied to the interface endpoints"
}

variable "enable" {
  type        = bool
  description = "Whether to create the SSM VPC endpoints"
  default     = true
}
