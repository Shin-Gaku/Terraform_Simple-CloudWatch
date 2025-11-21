# 作成したWAF WebACLのarnをモジュール外に渡す
output "web_acl_arn" {
  value = aws_wafv2_web_acl.wafwebacl.arn
}

# 作成したWAF WebACLのID
output "wafwebacl_id" {
  description = "WAF WebACLのID"
  value       = aws_wafv2_web_acl.wafwebacl.id
}

# 作成したCloudWatch Logsグループのid
output "cloudwatch_log_group_id" {
  description = "作成したCloudWatch LogsグループのID"
  value       = aws_cloudwatch_log_group.cloudwatch-loggp.id
}

# 作成したCloudWatch Logsグループのarn
output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.cloudwatch-loggp.arn
}