# /modules/routing/variables.tf

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

variable "tier_public" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "public"
}

variable "tier_private-web" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "private-web"
}

variable "tier_private-app" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "private-app"
}

variable "tier_private-db" {
  description = "Label to identify the tier (e.g. web, app)"
  type        = string
  default     = "private-db"
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
