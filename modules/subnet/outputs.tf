# /modules/subnet/outputs.tf

output "public_subnet_ids" {
  description = "Map of AZ to Public Subnet IDs"
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "private_web_subnet_ids" {
  description = "Map of AZ to Private Web Subnet IDs"
  value       = { for az, subnet in aws_subnet.private_web : az => subnet.id }
}

output "private_app_subnet_ids" {
  description = "Map of AZ to Private App Subnet IDs"
  value       = { for az, subnet in aws_subnet.private_app : az => subnet.id }
}

output "private_db_subnet_ids" {
  description = "Map of AZ to Private DB Subnet IDs"
  value       = { for az, subnet in aws_subnet.private_db : az => subnet.id }
}
