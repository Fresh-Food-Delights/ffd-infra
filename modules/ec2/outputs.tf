# /modules/ec2/outputs.tf

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = length(aws_instance.this) > 0 ? aws_instance.this[0].id : null
}

output "private_ip" {
  description = "Private IP of the instance"
  value       = length(aws_instance.this) > 0 ? aws_instance.this[0].private_ip : null
}
