# modules/subnet/outputs.tf

output "public_subnet_ids" {
  description = "Public subnets by AZ"
  value       = { for i, az in keys(var.public_subnet_cidrs) : az => aws_subnet.public[i].id }
}

output "private_web_subnet_ids" {
  description = "Private Web subnets by AZ"
  value       = { for i, az in keys(var.private_web_subnet_cidrs) : az => aws_subnet.private_web[i].id }
}

output "private_app_subnet_ids" {
  description = "Private App subnets by AZ"
  value       = { for i, az in keys(var.private_app_subnet_cidrs) : az => aws_subnet.private_app[i].id }
}

output "private_db_subnet_ids" {
  description = "Private DB subnets by AZ"
  value       = { for i, az in keys(var.private_db_subnet_cidrs) : az => aws_subnet.private_db[i].id }
}
