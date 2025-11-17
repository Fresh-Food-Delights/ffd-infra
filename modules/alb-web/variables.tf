# modules/alb-web/variables.tf

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, test, prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the ALB"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the ALB"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for the ALB"
}

variable "health_check_path" {
  type        = string
  description = "Path for ALB health check"
}

variable "acm_cert_arn" {
  type        = string
  description = "ARN of the ACM certificate"
}
