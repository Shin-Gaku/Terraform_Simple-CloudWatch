# モジュール名
variable "modules_name" {
  description = "各モジュールが共通に使用する名前"
  type        = string
}

# DBエンジン
variable "engine" {
  description = "DBエンジン"
  type        = string
  default     = "mysql"
}

# DBエンジンバージョン
variable "engine_version" {
  description = "DBエンジンバージョン"
  type        = string
  default     = "8.0.39"
}

# インスタンスの種類
variable "instance_class" {
  description = "インスタンスの種類"
  type        = string
  default     = "db.t4g.micro"
}

# RDSに割り当てるストレージの量
variable "allocated_storage" {
  description = "RDSに割り当てるストレージの量"
  type        = number
  default     = 20
}

# データベース名
variable "db_name" {
  description = "データベース名"
  type        = string
  default     = "awsstudy"
}

# DB管理ユーザー名
variable "rds_username" {
  description = "DB管理ユーザー名"
  type        = string
  default     = "root"
}

# RDSのパスワード
variable "rds_password" {
  description = "RDSのパスワード"
  type        = string
  sensitive   = true
}

# アベイラビリティゾーンのリスト
variable "AZs" {
  description = "AZsのリスト"
  type        = list(string)
}

# Multi-AZs構成にするかどうか
variable "multi_AZs" {
  description = "Multi-AZ構成にするか"
  type        = bool
  default     = false
}

# パブリックアクセスを許可するかどうか
variable "public_accessible" {
  description = "パブリックアクセスを許可するか"
  type        = bool
  default     = false
}

# ストレージタイプ
variable "storage_type" {
  description = "ストレージタイプ"
  type        = string
  default     = "gp3"
}

# メジャーバージョンアップを許可するかかどうか
variable "major_version_upgrade" {
  description = "メジャーバージョンアップを許可するかどうか"
  type        = bool
  default     = false
}

# マイナーバージョンアップを自動で行うかどうか
variable "auto_minor_version_upgrade" {
  description = "マイナーバージョンアップを自動で行うかどうか"
  type        = bool
  default     = true
}

# 削除保護を有効にするかどうか
variable "deletion_protection" {
  description = "削除保護を有効にするかどうか"
  type        = bool
  default     = false
}

# 削除時にスナップショットをスキップするかどうか
variable "skip_final_snapshot" {
  description = "削除時にスナップショットをスキップするかどうか"
  type        = bool
  default     = true
}

# RDS削除時に作成するスナップショットの名前
variable "final_snapshot_identifier" {
  description = "RDS削除時に作成するスナップショットの名前"
  type        = string
  default     = null
}

# RDSを配置するVPCのID
variable "vpc_id" {
  description = "RDSを配置するVPCのID"
  type        = string
}

# RDSにアクセスするEC2セキュリティグループのID
variable "ec2_sg_id" {
  description = "RDSにアクセスするEC2のセキュリティグループID"
  type        = string
}

# RDSを配置するプライベートサブネットのIDリスト
variable "private_subnet_ids" {
  description = "RDSを配置するプライベートサブネットのIDリスト"
  type        = list(string)
}