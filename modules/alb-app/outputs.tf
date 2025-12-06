# /modules/alb-app/outputs.tf

output "alb_arn" {
  value       = var.enable && length(aws_lb.this) > 0 ? aws_lb.this[0].arn : null
  description = "ARN of the app ALB"
}

output "alb_dns_name" {
  value       = var.enable && length(aws_lb.this) > 0 ? aws_lb.this[0].dns_name : null
  description = "DNS name of the app ALB"
}

output "target_group_arn" {
  value       = var.enable && length(aws_lb_target_group.this) > 0 ? aws_lb_target_group.this[0].arn : null
  description = "Target Group ARN for the app ALB"
}
