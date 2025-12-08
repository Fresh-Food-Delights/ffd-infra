# /modules/rds/outputs.tf

output "primary_instance_arn" {
  description = "ARN of the primary DB instance"
  value       = try(aws_db_instance.primary[0].arn, null)
}

output "primary_endpoint" {
  description = "Endpoint of the primary DB instance"
  value       = try(aws_db_instance.primary[0].address, null)
}

output "replica_endpoint" {
  description = "Endpoint of the read replica (if created)"
  value       = try(aws_db_instance.replica[0].address, null)
}
