# Availability Zones
variable "AZs" {
  description = "本VPCモジュールが使用するAZ"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

# VPCのCIDR
variable "vpc_cidr" {
  description = "VPCのCIDR"
  type        = string
  default     = "10.0.0.0/16"
}

# パブリックサブネットのCIDR
variable "public_subnets_cidr" {
  description = "パブリックサブネットCIDRリスト"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

# プライベートサブネットのCIDR
variable "private_subnets_cidr" {
  description = "プライベートサブネットCIDRリスト"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

# モジュール名
variable "modules_name" {
  description = "各モジュールが共通に使用する名前"
  type        = string
  #default     = "aws-study"
}