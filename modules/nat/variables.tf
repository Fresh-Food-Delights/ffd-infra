# /modules/nat/variables.tf

variable "environment" {
  description = "Deployment environment (dev, test, prod)"
  type        = string
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