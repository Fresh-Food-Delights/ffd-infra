# VPC ID and IGW ID
output "vpc_id" {
  description = "The ID of the main VPC"
  value       = aws_vpc.this.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

# ------------------------------------------------------------------------------
# VPC Endpoint Outputs
# ------------------------------------------------------------------------------

# Gateway Endpoints
output "vpce_s3_id" {
  description = "The ID of the S3 Gateway VPC Endpoint"
  value       = aws_vpc_endpoint.s3_gateway.id
}

output "vpce_dynamodb_id" {
  description = "The ID of the DynamoDB Gateway VPC Endpoint"
  value       = aws_vpc_endpoint.dynamodb_gateway.id
}

# Interface Endpoints
output "vpce_secretsmanager_id" {
  description = "The ID of the Secrets Manager Interface VPC Endpoint"
  value       = aws_vpc_endpoint.secretsmanager.id
}

output "vpce_ssm_id" {
  description = "The ID of the SSM Interface VPC Endpoint"
  value       = aws_vpc_endpoint.ssm.id
}

output "vpce_ssmmessages_id" {
  description = "The ID of the SSM Messages Interface VPC Endpoint"
  value       = aws_vpc_endpoint.ssmmessages.id
}

output "vpce_ec2messages_id" {
  description = "The ID of the EC2 Messages Interface VPC Endpoint"
  value       = aws_vpc_endpoint.ec2messages.id
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
  value       = aws_vpc_endpoint.secretsmanager_interface.id
}

output "vpce_ssm_id" {
  description = "The ID of the SSM VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.ssm_interface.id
}

output "vpce_ssmmessages_id" {
  description = "The ID of the SSMMESSAGES VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.ssmmessages_interface.id
}

output "vpce_ec2messages_id" {
  description = "The ID of the EC2MESSAGES VPC Endpoint (Interface Type)"
  value       = aws_vpc_endpoint.ec2messages_interface.id
}