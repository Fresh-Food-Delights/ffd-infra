# /envs/prod/us-east-1/outputs.tf

output "primary_instance_arn" {
  value = module.rds.primary_instance_arn
}

output "web_instance_profile_name" {
  description = "Instance profile name for web ASG"
  value       = module.iam.web_instance_profile_name
}

output "app_instance_profile_name" {
  description = "Instance profile name for app ASG"
  value       = module.iam.app_instance_profile_name
}

output "admin_group_name" {
  description = "Name of the IT admin IAM group"
  value       = module.iam.admin_group_name
}

output "ops_group_name" {
  description = "Name of the IT ops IAM group"
  value       = module.iam.ops_group_name
}
