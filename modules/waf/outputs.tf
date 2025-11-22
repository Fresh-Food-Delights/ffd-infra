# modules/waf/outputs.tf

output "waf_acl_arn" {
  description = "ARN of the Web ACL."
  value       = aws_wafv2_web_acl.app_waf.arn
}
