# /modules/secrets/outputs.tf

output "secret_arn" {
  description = "ARN of the DB credentials secret"
  value       = aws_secretsmanager_secret.db.arn
}

output "secret_name" {
  description = "Name of the DB credentials secret"
  value       = aws_secretsmanager_secret.db.name
}
