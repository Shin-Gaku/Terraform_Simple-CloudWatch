# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 3.0"
      version = "> 3.0"
    }
  }

  backend "s3" {
    bucket  = "awsstudy-tfstate-bucket-shingaku"
    key     = "awsstudy-shingaku.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

# ---------------------------------------------
# RDSマスターパスワード（ランダム） 
# ---------------------------------------------
resource "random_string" "db_password" {
  length  = 16
  special = false
}

# ---------------------------------------------------------------------
# IAM Policy Document (tfstate)
# ---------------------------------------------------------------------
data "aws_iam_policy_document" "policydoc_tfstate" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::awsstudy-tfstate-bucket-shingaku/*"]

    principals {
      type        = "AWS"
      identifiers = ["${local.account_id}"]
    }
  }
}

# ---------------------------------------------------------------------
# IAM Policy (tfstate)
# ---------------------------------------------------------------------
resource "aws_s3_bucket_policy" "policy_tfstate" {
  bucket = "awsstudy-tfstate-bucket-shingaku"
  policy = data.aws_iam_policy_document.policydoc_tfstate.json
}

# ---------------------------------------------------------------------
# IAM Policy Document (ec2 assume role)
# ---------------------------------------------------------------------
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ---------------------------------------------------------------------
# IAM Role
# ---------------------------------------------------------------------
resource "aws_iam_role" "app_iam_role" {
  name               = "${var.name_project}-${var.name_environment}-app-iam-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# ---------------------------------------------
# インスタンスプロファイルを定義
# ---------------------------------------------
resource "aws_iam_instance_profile" "app_ec2_profile" {
  name = aws_iam_role.app_iam_role.name
  role = aws_iam_role.app_iam_role.name
}

# ---------------------------------------------------------------------
# IAM Role Policy Attachment
# ---------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "app_iam_role_ec2_readonly" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "app_iam_role_ssm_managed" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "app_iam_role_ssm_readonly" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "app_iam_role_s3_readonly" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# ---------------------------------------------
# VPC (モジュールから呼び出す)
# ---------------------------------------------
module "aws-study-vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = "10.0.0.0/16"
  AZs          = ["ap-northeast-1a", "ap-northeast-1c"]
  modules_name = "aws-study"
}

# ---------------------------------------------
# EC2インスタンス (モジュールから呼び出す)
# ---------------------------------------------
module "ec2Instance" {
  source               = "./modules/ec2"
  instance_type        = var.ec2_type
  key_name             = var.key_name
  ssh_fixed_ip         = var.ssh_fixed_ip
  subnet_id            = module.aws-study-vpc.public_subnet_ids[0]
  vpc_id               = module.aws-study-vpc.vpc_id
  alb_sg_id            = module.alb.alb_sg_id
  iam_instance_profile = aws_iam_instance_profile.app_ec2_profile.name
  modules_name         = "aws-study"
}

# ---------------------------------------------
# ALB (モジュールから呼び出す)
# ---------------------------------------------
module "alb" {
  source       = "./modules/alb"
  ec2_id       = module.ec2Instance.instance_id
  subnet_ids   = module.aws-study-vpc.public_subnet_ids
  vpc_id       = module.aws-study-vpc.vpc_id
  modules_name = "aws-study"
}

# ---------------------------------------------
# SSM Parameter Store
# ---------------------------------------------
resource "aws_ssm_parameter" "password" {
  name  = "/${var.name_project}/${var.name_environment}/databases/rds/mysql/masterpwd"
  type  = "SecureString"
  value = random_string.db_password.result
}

# ---------------------------------------------
# RDSインスタンス (モジュールから呼び出す)
# ---------------------------------------------
module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.aws-study-vpc.vpc_id
  private_subnet_ids = module.aws-study-vpc.private_subnet_ids
  ec2_sg_id          = module.ec2Instance.ec2_sg_id
  rds_username       = var.db_username
  rds_password       = random_string.db_password.result
  AZs                = ["ap-northeast-1a", "ap-northeast-1c"]
  modules_name       = "aws-study"
}

# ---------------------------------------------
#  CloudWatch Alarm (モジュールから呼び出す)
# ---------------------------------------------
module "cloudwatchAlarm" {
  source             = "./modules/cloudwatch"
  ec2_id             = module.ec2Instance.instance_id
  notification_email = var.notification_email
  modules_name       = "aws-study"
}

# ---------------------------------------------
# WAF WebACL (モジュールから呼び出す)
# ---------------------------------------------
module "waf" {
  source       = "./modules/wafacls"
  alb_arn      = module.alb.alb_arn
  modules_name = "aws-study"
}