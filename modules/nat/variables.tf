# /modules/nat/variables.tf

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
  default     = "public"
}

variable "public_subnet_ids" {
  description = "Map of public subnet IDs keyed by AZ (e.g., us-east-1a)"
  type        = map(string)
}

variable "enable" {
  description = "Whether to create NAT gateways"
  type        = bool
  default     = false
}
