# ---------------------------------------------
# ALB セキュリティグループ
# ---------------------------------------------
resource "aws_security_group" "alb_sg" {
  name        = "${var.modules_name}-alb-sg"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.alb_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.modules_name}-alb-sg"
  }
}

# ---------------------------------------------
# ALB (モジュール定義)
# ---------------------------------------------
resource "aws_lb" "alb" {
  name               = "${var.modules_name}-alb"
  load_balancer_type = "application"
  internal           = var.internal
  ip_address_type    = "ipv4"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]
  tags = {
    Name = "${var.modules_name}-alb"
  }
}

# ---------------------------------------------
# ALB ターゲットグループ
# ---------------------------------------------
resource "aws_lb_target_group" "alb_tg" {
  name             = "${var.modules_name}-tg"
  port             = 8080
  protocol         = "HTTP"
  vpc_id           = var.vpc_id
  #protocol_version = "HTTP1"
  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 5  
    matcher             = "200,300,301"
  }
  tags = {
    Name = "${var.modules_name}-tg"
  }
}

#ALB target groupとEC2の関連付け
resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = var.ec2_id
  port             = 8080
}

# ---------------------------------------------
# ALB リスナー
# ---------------------------------------------
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}