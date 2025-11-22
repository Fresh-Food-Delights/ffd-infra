# modules/waf/main.tf

resource "aws_wafv2_web_acl" "app_waf" {
  name        = "${var.project_prefix}-web-acl-${var.environment}"
  scope       = "CLOUDFRONT"
  description = "Web ACL for the application using AWS Managed Rules."

  default_action {
    block {}
  }

  rule {
    name     = "AWS-CoreRuleSet"
    priority = 1

    action {
      allow {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CoreRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AppWafMetric"
    sampled_requests_enabled   = true
  }
}
