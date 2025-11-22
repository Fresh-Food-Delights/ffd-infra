# modules/iam/variables.tf

variable "project_prefix" {
  description = "A short prefix for resource naming (e.g., 'unit6' or 'ffd')."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, test, prod)."
  type        = string
}
