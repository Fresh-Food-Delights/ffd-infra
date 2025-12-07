# /modules/vpc_endpoints/outputs.tf

output "s3_endpoint_id" {
  description = "S3 gateway endpoint ID"
  value       = length(aws_vpc_endpoint.s3) > 0 ? aws_vpc_endpoint.s3[0].id : null
}

output "dynamodb_endpoint_id" {
  description = "DynamoDB gateway endpoint ID"
  value       = length(aws_vpc_endpoint.dynamodb) > 0 ? aws_vpc_endpoint.dynamodb[0].id : null
}

output "ssm_interface_endpoint_ids" {
  description = "SSM-related interface endpoint IDs (ssm, ssmmessages, ec2messages)"
  value = compact([
    length(aws_vpc_endpoint.ssm) > 0 ? aws_vpc_endpoint.ssm[0].id : null,
    length(aws_vpc_endpoint.ssmmessages) > 0 ? aws_vpc_endpoint.ssmmessages[0].id : null,
    length(aws_vpc_endpoint.ec2messages) > 0 ? aws_vpc_endpoint.ec2messages[0].id : null,
  ])
}

output "secretsmanager_endpoint_id" {
  description = "Secrets Manager interface endpoint ID"
  value       = length(aws_vpc_endpoint.secretsmanager) > 0 ? aws_vpc_endpoint.secretsmanager[0].id : null
}
