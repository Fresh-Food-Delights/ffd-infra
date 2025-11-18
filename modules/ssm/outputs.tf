# modules/ssm/outputs.tf

output "ssm_endpoint_id" {
  value       = length(aws_vpc_endpoint.ssm) > 0 ? aws_vpc_endpoint.ssm[0].id : null
  description = "ID of the SSM endpoint"
}

output "ssmmessages_endpoint_id" {
  value       = length(aws_vpc_endpoint.ssmmessages) > 0 ? aws_vpc_endpoint.ssmmessages[0].id : null
  description = "ID of the SSM Messages endpoint"
}

output "ec2messages_endpoint_id" {
  value       = length(aws_vpc_endpoint.ec2messages) > 0 ? aws_vpc_endpoint.ec2messages[0].id : null
  description = "ID of the EC2 Messages endpoint"
}
