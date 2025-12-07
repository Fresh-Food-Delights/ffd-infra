# /modules/ssm/outputs.tf

output "ssm_endpoint_id" {
  description = "VPC endpoint ID for SSM"
  value       = var.enable ? aws_vpc_endpoint.ssm[0].id : null
}

output "ssm_messages_endpoint_id" {
  description = "VPC endpoint ID for SSM Messages"
  value       = var.enable ? aws_vpc_endpoint.ssm_messages[0].id : null
}

output "ec2_messages_endpoint_id" {
  description = "VPC endpoint ID for EC2 Messages"
  value       = var.enable ? aws_vpc_endpoint.ec2_messages[0].id : null
}

output "ssm_instance_profile_name" {
  value       = try(aws_iam_instance_profile.ssm_instance_profile[0].name, null)
  description = "IAM instance profile to attach to EC2/ASG for SSM"
}
