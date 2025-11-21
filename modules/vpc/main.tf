# ---------------------------------------------
# VPC (モジュール定義)
# ---------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.modules_name}-vpc"
  }
}

# パブリックサブネット1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets_cidr[0]
  availability_zone       = var.AZs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.modules_name}-public-1"
  }
}

# パブリックサブネット2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets_cidr[1]
  availability_zone       = var.AZs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.modules_name}-public-2"
  }
}
# プライベートサブネット1
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnets_cidr[0]
  availability_zone       = var.AZs[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.modules_name}-private-1"
  }
}

# プライベートサブネット2
resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnets_cidr[1]
  availability_zone       = var.AZs[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.modules_name}-private-2"
  }
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.modules_name}-igw"
  }
}

# パブリックルートテーブル
resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.modules_name}-Public-RouteTable"
  }
}

# プライベートルートテーブル
resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.modules_name}-Public-RouteTable"
  }
}

# パブリックルート
resource "aws_route" "PublicRoute" {
  route_table_id         = aws_route_table.PublicRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# サブネットとルートテーブルの関連付け
# パブリックサブネットにルートテーブルを関連付け
resource "aws_route_table_association" "MyPublicSubnet1RouteTableAssociation" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "MyPublicSubnet2RouteTableAssociation" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

# プライベートサブネットにルートテーブルを関連付け
resource "aws_route_table_association" "PrivateSubnet1RouteTableAssociation" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

resource "aws_route_table_association" "PrivateSubnet2RouteTableAssociation" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}
