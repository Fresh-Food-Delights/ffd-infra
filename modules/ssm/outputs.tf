# modules/ssm/outputs.tf

output "ssm_endpoint_id" {
  value       = aws_vpc_endpoint.ssm.id
  description = "ID of the SSM endpoint"
}

output "ssmmessages_endpoint_id" {
  value       = aws_vpc_endpoint.ssmmessages.id
  description = "ID of the SSM Messages endpoint"
}

output "ec2messages_endpoint_id" {
  value       = aws_vpc_endpoint.ec2messages.id
  description = "ID of the EC2 Messages endpoint"
}
