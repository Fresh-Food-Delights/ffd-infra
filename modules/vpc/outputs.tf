# Output the core VPC ID (Must match resource naming: .this)
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id 
}

# Output the Internet Gateway ID (Must match resource naming: .this)
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

# --- VPC ENDPOINT OUTPUTS (Retrieved from vpc_endpoints submodule) ---
# These are passed through from the internal 'vpc_endpoints' module call to the parent VPC module.
output "vpce_s3_id" {
  description = "The ID of the S3 VPC Endpoint"
  value       = module.vpc_endpoints.vpce_s3_id
}

output "vpce_dynamodb_id" {
  description = "The ID of the DynamoDB VPC Endpoint"
  value       = module.vpc_endpoints.vpce_dynamodb_id
}

output "vpce_ssm_id" {
  description = "The ID of the SSM VPC Endpoint"
  value       = module.vpc_endpoints.vpce_ssm_id
}

output "vpce_ssmmessages_id" {
  description = "The ID of the SSMMESSAGES VPC Endpoint"
  value       = module.vpc_endpoints.vpce_ssmmessages_id
}

output "vpce_ec2messages_id" {
  description = "The ID of the EC2MESSAGES VPC Endpoint"
  value       = module.vpc_endpoints.vpce_ec2messages_id
}

output "vpce_kms_id" {
  description = "The ID of the KMS VPC Endpoint"
  value       = module.vpc_endpoints.vpce_kms_id
}

output "vpce_secretsmanager_id" {
  description = "The ID of the Secrets Manager VPC Endpoint"
  value       = module.vpc_endpoints.vpce_secretsmanager_id
}