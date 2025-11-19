# modules/alb-app/variables.tf

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

variable "internal" {
  description = "Whether the ALB is internal or internet-facing"
  type        = bool
}

variable "target_port" {
  description = "Port for the target group and listener"
  type        = number
}

variable "tier" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
}

variable "enable" {
  description = "Whether to create the web-facing ALB"
  type        = bool
  default     = false
}
