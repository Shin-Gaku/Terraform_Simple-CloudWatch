# ログの保持期間（日数）
variable "log_retention" {
  description = "ログの保持期間（日数）"
  type        = number
  default     = 7
}

# モジュール名
variable "modules_name" {
  description = "各モジュールが共通に使用する名前"
  type        = string
}

# （他のモジュールで作成した）ALBのARN
variable "alb_arn" {
  type        = string
  description = "（他のモジュールで作成した）ALBのARN"
}

