# ---------------------------------------------
# AMIは最新のAMI IDをパラメータストアから取得する
# ---------------------------------------------
data "aws_ami" "amazon_linux_deflt" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
}

# ---------------------------------------------
# EC2インスタンス (モジュール定義)
# ---------------------------------------------
resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.amazon_linux_deflt.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "${var.modules_name}-ec2"
  }
}

# EC2用セキュリティグループ
resource "aws_security_group" "ec2_sg" {
  name        = "${var.modules_name}-sg"
  description = "security group for ec2"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_fixed_ip]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
    #cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.modules_name}-sg"
  }
}