# modules/iam/outputs.tf

output "iam_role_arn" {
  description = "The ARN of the application service role used by EC2."
  value       = aws_iam_role.app_service_role.arn
}
