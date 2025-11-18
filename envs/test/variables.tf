variable "region" {
  type        = string
  description = "AWS region to deploy resources into"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
  default     = "test"
}

variable "enable_nat" {
  type        = bool
  description = "Toggle NAT Gateway creation"
  default     = false
}

variable "enable_alb_web" {
  type        = bool
  description = "Toggle public web-facing ALB"
  default     = false
}

variable "enable_alb_app" {
  type        = bool
  description = "Toggle private app-facing ALB"
  default     = false
}

variable "enable_ec2" {
  type        = bool
  description = "Toggle EC2 instance (AMI builder)"
  default     = false
}

variable "enable_ssm" {
  type        = bool
  description = "Toggle SSM agent-related infrastructure"
  default     = false
}
