# --- VPC ENDPOINT OUTPUTS (Gateway Endpoints) ---

output "vpce_s3_id" {
  description = "The ID of the S3 VPC Endpoint (Gateway Type)"
  value       = aws_vpc_endpoint.s3_gateway.id
}

output "vpce_dynamodb_id" {
  description = "The ID of the DynamoDB VPC Endpoint (Gateway Type)"
  value       = aws_vpc_endpoint.dynamodb_gateway.id
}

# --- VPC ENDPOINT OUTPUTS (Interface Endpoints) ---

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