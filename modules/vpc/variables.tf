# Define the environment name for tagging and prefixing resources
variable "environment" {
  description = "The environment name (e.g., dev, prod) used for resource naming."
  type        = string
}

# Define the CIDR block for the VPC
variable "vpc_cidr" {
  description = "The CIDR block for the VPC (e.g., 10.0.0.0/16)."
  type        = string
}

# ------------------------------------------------------------------
# INPUTS FOR VPC ENDPOINTS SUBMODULE (NEW REQUIRED VARIABLES)
# ------------------------------------------------------------------

# Security Group ID for Interface Endpoints
variable "vpc_endpoint_security_group_id" {
  description = "The Security Group ID used to secure VPC Interface Endpoints."
  type        = string
}

# Subnet IDs where VPC Interface Endpoints will be placed
variable "private_web_subnet_ids" {
  description = "List of IDs for private web tier subnets."
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "List of IDs for private app tier subnets."
  type        = list(string)
}

variable "private_db_subnet_ids" {
  description = "List of IDs for private DB tier subnets."
  type        = list(string)
}