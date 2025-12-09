# /modules/cloudfront/outputs.tf

output "distribution_id" {
  value       = try(aws_cloudfront_distribution.this[0].id, null)
  description = "CloudFront distribution ID"
}

output "distribution_domain_name" {
  value       = try(aws_cloudfront_distribution.this[0].domain_name, null)
  description = "CloudFront distribution domain name"
}
