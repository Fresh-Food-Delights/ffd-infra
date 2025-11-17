# modules/alb-app/outputs.tf

output "alb_arn" {
  value       = aws_lb.this.arn
  description = "ARN of the app ALB"
}

output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "DNS name of the app ALB"
}

output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
  description = "Target Group ARN for the app ALB"
}
