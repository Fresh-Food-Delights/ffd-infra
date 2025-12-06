# /modules/routing/variables.tf

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for routing"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID for public tier routing"
  type        = string
  default     = null
}

variable "enable_public_internet" {
  description = "Whether to allow public tier outbound access (via IGW)"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT routes for private web tier"
  type        = bool
  default     = false
}

variable "nat_gateway_ids" {
  description = "Map of AZ to NAT Gateway IDs for private web tier"
  type        = map(string)
  default     = {}
}

# Subnet-to-Route Table Associations
variable "public_subnet_ids" {
  description = "Map of public subnet IDs per AZ"
  type        = map(string)
}

variable "private_web_subnet_ids" {
  description = "Map of private web subnet IDs per AZ"
  type        = map(string)
}

variable "private_app_subnet_ids" {
  description = "Map of private app subnet IDs per AZ"
  type        = map(string)
}

variable "private_db_subnet_ids" {
  description = "Map of private db subnet IDs per AZ"
  type        = map(string)
}

# Optional VPC Endpoint IDs
variable "vpce_s3_id" {
  description = "VPC endpoint ID for S3"
  type        = string
  default     = null
}

variable "vpce_dynamodb_id" {
  description = "VPC endpoint ID for DynamoDB"
  type        = string
  default     = null
}

variable "vpce_ssm_id" {
  description = "VPC endpoint ID for SSM"
  type        = string
  default     = null
}

variable "vpce_secretsmanager_id" {
  description = "VPC endpoint ID for Secrets Manager"
  type        = string
  default     = null
}

variable "vpce_kms_id" {
  description = "VPC endpoint ID for KMS"
  type        = string
  default     = null
}

variable "vpce_ssmmessages_id" {
  description = "VPC endpoint ID for SSM Messages"
  type        = string
  default     = null
}

variable "vpce_ec2messages_id" {
  description = "VPC endpoint ID for EC2 Messages"
  type        = string
  default     = null
}
