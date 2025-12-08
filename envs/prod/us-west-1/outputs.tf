# /envs/prod/us-west-1/outputs.tf

output "primary_instance_arn" {
  value = module.rds.primary_instance_arn
}
