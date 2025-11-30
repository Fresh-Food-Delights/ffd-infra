# ==============================================================================
# VPC MODULE OUTPUTS
#
# Exposes core VPC IDs and all VPC Endpoint IDs for use in other modules
# (e.g., routing, security, and application layers).
# ==============================================================================

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
#
# Gateway Endpoints are typically defined as standalone resources (no count/for_each).
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
#
# Interface Endpoints are grouped using a 'for_each' block named 'interface_endpoints',
# requiring a map key lookup (e.g., ["secretsmanager"]) to get the specific ID.
# -----------------------------------------------------------------------------
output "vpce_secretsmanager_id" {
  description = "The ID of the Secrets Manager VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.interface_endpoints["secretsmanager"].id
}

output "vpce_ssm_id" {
  description = "The ID of the SSM VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.interface_endpoints["ssm"].id
}

output "vpce_ssmmessages_id" {
  description = "The ID of the SSMMESSAGES VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.interface_endpoints["ssmmessages"].id
}

output "vpce_ec2messages_id" {
  description = "The ID of the EC2MESSAGES VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.interface_endpoints["ec2messages"].id
}