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
# VPC ENDPOINT OUTPUTS (Gateway Endpoints) - FIX APPLIED: Added [0] index
# -----------------------------------------------------------------------------
output "vpce_s3_id" {
  description = "The ID of the S3 VPC Endpoint (Gateway Type)"
  # FIX: Assumes count/for_each was used in endpoints.tf, requiring [0] index
  value       = aws_vpc_endpoint.s3_gateway[0].id
}

output "vpce_dynamodb_id" {
  description = "The ID of the DynamoDB VPC Endpoint (Gateway Type)"
  # FIX: Assumes count/for_each was used in endpoints.tf, requiring [0] index
  value       = aws_vpc_endpoint.dynamodb_gateway[0].id
}

# -----------------------------------------------------------------------------
# VPC ENDPOINT OUTPUTS (Interface Endpoints) - Minor review for consistent naming
# -----------------------------------------------------------------------------
output "vpce_secretsmanager_id" {
  description = "The ID of the Secrets Manager VPC Endpoint (Interface Type)"
  # Assuming no count for interface endpoints, or that the name 'secretsmanager' is correct.
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