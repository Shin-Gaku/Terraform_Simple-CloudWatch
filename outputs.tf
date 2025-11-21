# VPC ID
output "vpc_id" {
  description = "モジュールaws-study-vpcが作成されたVPCのID"
  value       = module.aws-study-vpc.vpc_id
}

# EC2インスタンスIDの出力
output "ec2_id" {
  description = "EC2インスタンスID"
  value       = module.ec2Instance.instance_id
}

# 作成したEC2インスタンスIP
output "ec2_public_ip" {
  description = "EC2インスタンスIP"
  value       = module.ec2Instance.ec2_public_ip
}

# ALB DNS名
output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "ALBのDNS名"
}

# RDS IDの出力
output "rds_id" {
  description = "RDSのID"
  value       = module.rds.rds_id
}

# Cloudwatch Alarm IDの出力
output "cloudwatchAlarm_ec2cpu_id" {
  description = "Cloudwatch AlarmのID"
  value       = module.cloudwatchAlarm.cloudwatchAlarm_ec2cpu_id
}

# WAF WebACL IDの出力
output "wafwebacl_id" {
  description = "WAF WebACLのID"
  value       = module.waf.wafwebacl_id
}