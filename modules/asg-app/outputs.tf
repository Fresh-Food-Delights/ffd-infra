# /modules/asg-app/outputs.tf

output "asg_name" {
  value       = aws_autoscaling_group.this.name
  description = "Name of the Auto Scaling Group"
}

output "launch_template_id" {
  value       = aws_launch_template.this.id
  description = "ID of the launch template"
}
