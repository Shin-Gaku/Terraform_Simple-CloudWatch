# モジュール名
variable "modules_name" {
  description = "各モジュールが共通に使用する名前"
  type        = string
}

# EC2のインスタンスタイプ
variable "instance_type" {
  type = string
  default = "t2.micro"
}

# EC2のキーペア名
variable "key_name" {
  description = "EC2が使用する作成済みSSHキーペア名"
  type        = string
}

# EC2を配置するするサブネットID
variable "subnet_id" {
  description = "EC2を配置するサブネットID"
  type        = string
}

# EC2が所属するVPCのID
variable "vpc_id" {
  description = "EC2が所属するVPCのID"
  type        = string
}

# 管理者SSHアクセス用固定IPアドレス
variable "ssh_fixed_ip" {
  description = "管理者SSHアクセス用固定IPアドレス"
  type        = string
}

# EC2が所属するALBのセキュリティグループID
variable "alb_sg_id" {
  description = "Security Group ID of the ALB which can access to EC2"
  type        = string
}