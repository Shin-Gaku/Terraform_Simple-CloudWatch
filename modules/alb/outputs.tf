# 作成したALBのIDをモジュール外に渡す
output "alb_id" {
  description = "ALBのID"
  value       = aws_lb.alb.id
}

# 作成したALBのARN
output "alb_arn" {
  description = "ALBのARN"
  value       = aws_lb.alb.arn
}

# 作成したALBのDNS名
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

# 作成したALBセキュリティグループのID
output "alb_sg_id" {
  description = "ALBセキュリティグループのID"
  value       = aws_security_group.alb_sg.id
}

# 作成したターゲットグループのID
output "tg_id" {
  description = "ターゲットグループのID"
  value       = aws_lb_target_group.alb_tg.id
}

# 作成したターゲットグループのARN
output "tg_arn" {
  description = "ターゲットグループのarn"
  value       = aws_lb_target_group.alb_tg.arn
}