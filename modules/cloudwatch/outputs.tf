# 作成したCloudWatch AlarmのIDをモジュール外に渡す
output "cloudwatchAlarm_ec2cpu_id" {
  description = "CloudWatch Alarm for CPU utilization of EC2"
  value       = aws_cloudwatch_metric_alarm.cloudwatchAlarm_ec2cpu.id
}