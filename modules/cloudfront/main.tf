# /modules/cloudfront/main.tf

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }
}

resource "aws_cloudfront_distribution" "this" {
  count = var.enable ? 1 : 0
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "ffd-${var.environment}-web"
  default_root_object = ""
  origin {
    domain_name = var.origin_domain_name
    origin_id   = "ffd-${var.environment}-web-alb"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    target_origin_id       = "ffd-${var.environment}-web-alb"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress = true
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.geo_restriction_countries
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  web_acl_id = var.web_acl_arn != "" ? var.web_acl_arn : null
  tags = {
    Environment = var.environment
    Region      = var.region
    Tier        = var.tier
  }
}
