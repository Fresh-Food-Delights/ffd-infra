# modules/subnet/outputs.tf

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_web_subnet_ids" {
  description = "List of private web subnet IDs"
  value       = [for subnet in aws_subnet.private_web : subnet.id]
}

output "private_app_subnet_ids" {
  description = "List of private app subnet IDs"
  value       = [for subnet in aws_subnet.private_app : subnet.id]
}

output "private_db_subnet_ids" {
  description = "List of private db subnet IDs"
  value       = [for subnet in aws_subnet.private_db : subnet.id]
}
