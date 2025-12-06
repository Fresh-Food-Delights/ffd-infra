# /modules/security/outputs.tf

output "security_group_id" {
  value       = aws_security_group.this.id
  description = "ID of the created security group"
}

output "security_group_name" {
  value       = aws_security_group.this.name
  description = "Name of the security group"
}