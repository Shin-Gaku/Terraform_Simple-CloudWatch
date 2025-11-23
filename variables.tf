# プロジェクト名
variable "name_project" {
  description = "プロジェクト名"
  type        = string
  default     = "aws-study"
}

# プロジェクト名
variable "name_environment" {
  description = "独自の環境名"
  type        = string
  default     = "gakushindev"
}

# EC2のインスタンスタイプ
variable "ec2_type" {
  type    = string
  default = "t3.micro"
}

# EC2のキーペア名
variable "key_name" {
  description = "EC2が使用する作成済みSSHキーペア名"
  type        = string
  default     = "aws-study_20251010"
}

# 管理者SSHアクセス用固定IPアドレス
variable "ssh_fixed_ip" {
  description = "管理者SSHアクセス用固定IPアドレス"
  type        = string
  #default     = "128.169.2.50/32"
  default = "0.0.0.0/0"
}

# RDS管理者ログイン名
variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "root"
}

# RDS管理者ログインパスワード
variable "db_password" {
  description = "RDS master password"
  type        = string
  default     = "rootroot"
  sensitive   = true
}

# アラームの通知先メールアドレス
variable "notification_email" {
  description = "アラートの通知先メールアドレス"
  type        = string
  default     = "yakushin-co.ltd@gol.com"
  sensitive   = true
}