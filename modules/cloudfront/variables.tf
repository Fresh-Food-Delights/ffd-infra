# /modules/cloudfront/variables.tf

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
  default     = "edge"
}

variable "origin_domain_name" {
  type        = string
  description = "Origin DNS name (e.g., ALB DNS)"
}

variable "geo_restriction_countries" {
  description = "Allowed countries for CloudFront geo restriction"
  type        = list(string)
  default     = ["US"]
}

variable "web_acl_arn" {
  type        = string
  description = "Optional WAF Web ACL ARN"
  default     = ""
}

variable "enable" {
  type        = bool
  description = "Toggle CloudFront distribution"
  default     = false
}
