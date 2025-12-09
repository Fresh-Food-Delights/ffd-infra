# /modules/subnet/variables.tf

variable "environment" {
  type        = string
  description = "Environment name (dev, test, prod)"
  default = "dev"
}

variable "region" {
  description = "AWS region (e.g., us-east-1)"
  type        = string
  default = "us-east-1"
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
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Map of AZ → CIDR for public subnets"
  type        = map(string)
}

variable "private_web_subnet_cidrs" {
  description = "Map of AZ → CIDR for private web subnets"
  type        = map(string)
}

variable "private_app_subnet_cidrs" {
  description = "Map of AZ → CIDR for private app subnets"
  type        = map(string)
}

variable "private_db_subnet_cidrs" {
  description = "Map of AZ → CIDR for private db subnets"
  type        = map(string)
}
