# ---------------------------------------------
# cloudwatch (モジュール定義)
# ---------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cloudwatchAlarm_ec2cpu" {
  alarm_name          = "${var.modules_name}-cloudwatchAlarm_ec2cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  datapoints_to_alarm = var.limit_to_alarm
  alarm_description   = "this alarm monitors EC2 CPU utilization"
  dimensions = {
    InstanceId = var.ec2_id
  }
}