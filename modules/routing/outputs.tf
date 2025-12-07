# /modules/routing/outputs.tf

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "private_web_route_table_id" {
  description = "Web tier route table ID"
  value       = aws_route_table.private_web.id
}

output "private_app_route_table_id" {
  description = "App tier route table ID"
  value       = aws_route_table.private_app.id
}

output "private_db_route_table_id" {
  description = "DB tier route table ID"
  value       = aws_route_table.private_db.id
}
