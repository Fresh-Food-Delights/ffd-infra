# /modules/nat/variables.tf

variable "environment" {
  description = "Environment name (e.g. dev, test, prod)"
  type        = string
}

variable "public_subnet_ids" {
  description = "Map of AZs to public subnet IDs where NAT Gateways will be deployed"
  type        = map(string)
}

variable "enable" {
  description = "Whether to enable NAT Gateway deployment"
  type        = bool
  default     = false
}
