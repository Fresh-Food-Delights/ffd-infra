# modules/waf/variables.tf

variable "project_prefix" {
  description = "Prefix for resource naming (e.g., 'unit6' or 'ffd')."
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)."
  type        = string
}
