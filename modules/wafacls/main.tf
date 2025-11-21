# ---------------------------------------------
# CloudWatch Logs グループ
# ---------------------------------------------
resource "aws_cloudwatch_log_group" "cloudwatch-loggp" {
  name              = "aws-waf-logs-${var.modules_name}"
  retention_in_days = var.log_retention
}

# ---------------------------------------------
#  WAF WebACL (モジュール定義)
# ---------------------------------------------
resource "aws_wafv2_web_acl" "wafwebacl" {
  name        = "${var.modules_name}-waf-web-acl"
  description = "WAF Web ACLs"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.modules_name}-web-acl"
    sampled_requests_enabled   = true
  }
  tags = {
    Name = "${var.modules_name}-waf-web-acl"
  }
}

# ---------------------------------------------
# ALBとの関連付け
# ---------------------------------------------
resource "aws_wafv2_web_acl_association" "wafwebacl-association" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.wafwebacl.arn
}

# ---------------------------------------------
# WAF ログ設定
# ---------------------------------------------
resource "aws_wafv2_web_acl_logging_configuration" "cloudwatch_logging" {
  resource_arn = aws_wafv2_web_acl.wafwebacl.arn

  log_destination_configs = [
    aws_cloudwatch_log_group.cloudwatch-loggp.arn
  ]

  depends_on = [
    aws_wafv2_web_acl.wafwebacl,
    aws_cloudwatch_log_group.cloudwatch-loggp,
  ]

  # ログフィルター例
  logging_filter {
    default_behavior = "DROP"

    filter {
      requirement = "MEETS_ANY"
      behavior    = "KEEP"

      condition {
        action_condition {
          action = "BLOCK"
        }
      }
      condition {
        action_condition {
          action = "COUNT"
        }
      }
    }
  }

  # ヘッダーのマスク例
  redacted_fields {
    single_header {
      name = "authorization"
    }
  }
}