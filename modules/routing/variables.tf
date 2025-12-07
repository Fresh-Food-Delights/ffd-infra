# /modules/routing/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev/test/prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "internet_gateway_id" {
  description = "ID of the Internet Gateway used for public route table default routes"
  type        = string
}

variable "nat_gateway_ids" {
  description = "List of NAT gateway IDs to use for private web egress"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to use NAT for web tier outbound"
  default     = false
}

variable "public_subnet_ids" {
  type        = map(string)
  description = "Map of AZ -> public subnet IDs"
}

variable "private_web_subnet_ids" {
  type        = map(string)
  description = "Map of AZ -> private web subnet IDs"
}

variable "private_app_subnet_ids" {
  type        = map(string)
  description = "Map of AZ -> private app subnet IDs"
}

variable "private_db_subnet_ids" {
  type        = map(string)
  description = "Map of AZ -> private db subnet IDs"
}