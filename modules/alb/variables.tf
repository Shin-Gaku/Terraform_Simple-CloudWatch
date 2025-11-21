# モジュール名
variable "modules_name" {
  description = "各モジュールが共通に使用する名前"
  type        = string
}

# ALB Target Groupに所属するEC2インスタンスID
variable "ec2_id" {
  description = "EC2 instance ID to attach to Target Group"
  type        = string
}

# ALBを内部向けにするかどうかの指定
variable "internal" {
  description = "ALBを内部向けにするかの指定"
  type        = bool
  default     = false
}

# ALBを配置するサブネットのリスト
variable "subnet_ids" {
  description = "ALBを配置するサブネットIDリスト"
  type        = list(string)
}

# ALBを配置するVPCのID
variable "vpc_id" {
  description = "ALBを配置するVPCのID"
  type        = string
}

# ヘルスチェックのパス
variable "health_check_path" {
  description = "ヘルスチェックのパス"
  type        = string
  default     = "/"
}

variable "alb_cidr" {
  description = "ALB にアクセスするCIDR"
  type        = string
  default     = "0.0.0.0/0"
}