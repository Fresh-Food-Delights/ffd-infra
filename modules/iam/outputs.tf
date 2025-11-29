# modules/iam/outputs.tf

output "admin_group_name" {
  description = "Name of the IT admin IAM group"
  value       = aws_iam_group.it_admin_group.name
}

output "admin_group_id" {
  description = "ID of the IT admin IAM group"
  value       = aws_iam_group.it_admin_group.id
}

output "ops_group_name" {
  description = "Name of the IT ops IAM group"
  value       = aws_iam_group.it_ops_group.name
}

output "ops_group_id" {
  description = "ID of the IT ops IAM group"
  value       = aws_iam_group.it_ops_group.id
}
