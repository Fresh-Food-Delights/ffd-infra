# modules/iam/outputs.tf

output "admin_group_name" {
  description = "Name of the IT admin IAM group"
  value       = aws_iam_group.it_admin.name
}

output "admin_group_id" {
  description = "ID of the IT admin IAM group"
  value       = aws_iam_group.it_admin.id
}

output "ops_group_name" {
  description = "Name of the IT ops IAM group"
  value       = aws_iam_group.it_ops.name
}

output "ops_group_id" {
  description = "ID of the IT ops IAM group"
  value       = aws_iam_group.it_ops.id
}
