# /modules/vpc_endpoints/variables.tf

variable "vpc_id" {
  description = "VPC ID where endpoints will be created"
  type        = string
}

variable "region" {
  description = "AWS region (e.g., us-east-1)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs (one per AZ) for interface endpoints"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "Private route table IDs (web/app/db) for gateway endpoints"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs to attach to interface endpoints"
  type        = list(string)
}

variable "enable_s3" {
  description = "Enable S3 gateway endpoint"
  type        = bool
  default     = true
}

variable "enable_dynamodb" {
  description = "Enable DynamoDB gateway endpoint"
  type        = bool
  default     = true
}

variable "enable_ssm" {
  description = "Enable SSM interface endpoints (ssm, ssmmessages, ec2messages)"
  type        = bool
  default     = false
}

variable "enable_secretsmanager" {
  description = "Enable Secrets Manager interface endpoint"
  type        = bool
  default     = false
}
