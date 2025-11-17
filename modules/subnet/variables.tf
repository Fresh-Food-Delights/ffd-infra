# modules/subnet/variables.tf

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, test, prod)"
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
