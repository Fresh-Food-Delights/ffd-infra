# modules/alb-web/outputs.tf

output "alb_arn" {
  value       = aws_lb.this.arn
  description = "ARN of the web ALB"
}

output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "DNS name of the web ALB"
}

output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
  description = "Target Group ARN for the web ALB"
}
