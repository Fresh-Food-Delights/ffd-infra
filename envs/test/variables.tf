# envs/test/variables.tf

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

variable "acm_cert_arn" {
  description = "ARN of the ACM certificate for ALB listener"
  type        = string
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

variable "ami_id" {
  description = "AMI ID to use for instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for ASG EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "user_data_base64" {
  description = "Base64-encoded user data for EC2 instances"
  type        = string
  default     = ""
}

variable "enable_ec2" {
  type        = bool
  description = "Toggle EC2 instance (AMI builder)"
  default     = false
}

variable "enable_ssm" {
  description = "Whether to enable SSM VPC endpoints"
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}
