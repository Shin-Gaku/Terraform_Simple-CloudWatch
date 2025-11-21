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
  source        = "./modules/ec2"
  instance_type = var.ec2_type
  key_name      = var.key_name
  ssh_fixed_ip  = var.ssh_fixed_ip
  subnet_id     = module.aws-study-vpc.public_subnet_ids[0]
  vpc_id        = module.aws-study-vpc.vpc_id
  alb_sg_id     = module.alb.alb_sg_id
  modules_name  = "aws-study"
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
# RDSインスタンス (モジュールから呼び出す)
# ---------------------------------------------
module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.aws-study-vpc.vpc_id
  private_subnet_ids = module.aws-study-vpc.private_subnet_ids
  ec2_sg_id          = module.ec2Instance.ec2_sg_id
  rds_username       = var.db_username
  rds_password       = var.db_password
  AZs                = ["ap-northeast-1a", "ap-northeast-1c"]
  modules_name       = "aws-study"
}

# ---------------------------------------------
#  CloudWatch Alarm (モジュールから呼び出す)
# ---------------------------------------------
module "cloudwatchAlarm" {
  source       = "./modules/cloudwatch"
  ec2_id       = module.ec2Instance.instance_id
  modules_name = "aws-study"
}

# ---------------------------------------------
# WAF WebACL (モジュールから呼び出す)
# ---------------------------------------------
module "waf" {
  source       = "./modules/wafacls"
  alb_arn      = module.alb.alb_arn
  modules_name = "aws-study"
}