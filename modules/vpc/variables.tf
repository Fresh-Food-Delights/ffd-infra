# modules/vpc/variables.tf

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)."
  type        = string
}

# --- VPC Endpoint Required Variables ---
# These are required to place the Interface Endpoints in the correct subnets.
variable "private_web_subnet_ids" {
  description = "A list of private web subnet IDs, required for placing interface endpoints."
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "A list of private app subnet IDs, required for placing interface endpoints."
  type        = list(string)
}

variable "private_db_subnet_ids" {
  description = "A list of private db subnet IDs, required for placing interface endpoints."
  type        = list(string)
}

# --- Optional Interface Endpoints ---
# These are required only if we are using the subnets module to create the subnets.
variable "enable_public_internet" {
  description = "Controls whether the public route table has a route to the IGW."
  type        = bool
  default     = true
}

variable "vpc_endpoint_security_group_id" {
  description = "The ID of the Security Group to attach to the VPC Endpoints."
  type        = string
}
