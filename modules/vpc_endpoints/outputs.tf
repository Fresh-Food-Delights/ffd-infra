# /modules/vpc_endpoints/outputs.tf

output "s3_endpoint_id" {
  description = "S3 gateway endpoint ID"
  value       = aws_vpc_endpoint.s3.id
}

output "dynamodb_endpoint_id" {
  description = "DynamoDB gateway endpoint ID"
  value       = aws_vpc_endpoint.dynamodb.id
}
