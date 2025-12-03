variable "environment" {
  description = "The environment name (e.g., dev, prod)."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to create the security group in."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC. Used to restrict ingress traffic."
  type        = string
}
# -----------------------------------------------------------------------------
# CORE VPC OUTPUTS
# -----------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# -----------------------------------------------------------------------------
# VPC ENDPOINT OUTPUTS (Gateway Endpoints)
# -----------------------------------------------------------------------------
output "vpce_s3_id" {
  description = "The ID of the S3 VPC Endpoint (Gateway Type)"
  value       = aws_vpc_endpoint.s3_gateway.id
}

output "vpce_dynamodb_id" {
  description = "The ID of the DynamoDB VPC Endpoint (Gateway Type)"
  value       = aws_vpc_endpoint.dynamodb_gateway.id
}

# -----------------------------------------------------------------------------
# VPC ENDPOINT OUTPUTS (Interface Endpoints)
# -----------------------------------------------------------------------------
output "vpce_secretsmanager_id" {
  description = "The ID of the Secrets Manager VPC Endpoint (Interface Type)"
  # NOTE: The resource name here must match the one used in vpc/endpoints.tf
  value       = aws_vpc_endpoint.secretsmanager.id
}

output "vpce_ssm_id" {
  description = "The ID of the SSM VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.ssm.id
}

output "vpce_ssmmessages_id" {
  description = "The ID of the SSMMESSAGES VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.ssmmessages.id
}

output "vpce_ec2messages_id" {
  description = "The ID of the EC2MESSAGES VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.ec2messages.id
}