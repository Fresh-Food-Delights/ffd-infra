# /modules/routing/outputs.tf

output "public_route_table_id" {
  description = "Route table ID for the public subnet tier"
  value       = aws_route_table.public.id
}

output "private_web_route_table_id" {
  description = "Route table ID for the private web subnet tier"
  value       = aws_route_table.private_web.id
}

output "private_app_route_table_id" {
  description = "Route table ID for the private app subnet tier"
  value       = aws_route_table.private_app.id
}

output "private_db_route_table_id" {
  description = "Route table ID for the private db subnet tier"
  value       = aws_route_table.private_db.id
}
