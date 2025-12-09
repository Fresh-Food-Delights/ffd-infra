# /modules/waf/outputs.tf

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = try(aws_wafv2_web_acl.this[0].arn, null)
}
