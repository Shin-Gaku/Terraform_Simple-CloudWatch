# モジュール名
variable "modules_name" {
  description = "各モジュールが共通に使用する名前"
  type        = string
}

# 監視対象EC2のID
variable "ec2_id" {
  description = "監視対象EC2のID"
  type        = string
}

# 評価期間（連続評価の回数）
variable "evaluation_periods" {
  description = "評価期間（回数）"
  type        = number
  default     = 1 #1回の評価でアラームを発生
}

# 1回の評価の統計期間（秒）
variable "period" {
  description = "統計期間（秒）"
  type        = number
  default     = 60 #1分ごとに監視
}

# 統計方法
variable "statistic" {
  description = "統計方法"
  type        = string
  default     = "Average"
}

# CPU使用率の閾値
variable "threshold" {
  description = "CPU使用率の閾値"
  type        = number
  default     = 80
}

# どのくらい閾値を超えたらアラームを発生させるリミット値
variable "limit_to_alarm" {
  description = "統計期間（秒）"
  type        = number
  default     = 1 #1データポイントが閾値を超えたらアラーム
}

# アラームの通知先メールアドレス
variable "notification_email" {
  description = "アラートの通知先メールアドレス"
  type        = string
  sensitive   = true
}