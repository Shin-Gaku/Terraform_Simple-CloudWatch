# ---------------------------------------------
# RDSセキュリティグループ
# ---------------------------------------------
resource "aws_security_group" "rds_sg" {
  name        = "${var.modules_name}-rds-sg"
  description = "security_group which can access RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    description = "(EC2)security_group which can access RDS"
    security_groups = [var.ec2_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.modules_name}-rds-sg"
  }
}

# ---------------------------------------------
# DBサブネットグループ
# ---------------------------------------------
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.modules_name}-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "${var.modules_name}-rds-subnetgroup"
  }
}

# ---------------------------------------------
# RDSインスタンス (モジュール定義)
# ---------------------------------------------
resource "aws_db_instance" "rds" {
  identifier                  = "${var.modules_name}-rds"
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = var.allocated_storage
  db_name                     = var.db_name
  username                    = var.rds_username
  password                    = var.rds_password
  availability_zone           = var.AZs[0]
  multi_az                    = var.multi_AZs
  publicly_accessible         = var.public_accessible
  storage_type                = var.storage_type
  allow_major_version_upgrade = var.major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  deletion_protection         = var.deletion_protection
  skip_final_snapshot         = var.skip_final_snapshot
  final_snapshot_identifier   = var.final_snapshot_identifier
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  tags = {
    Name = "${var.modules_name}-rds"
  }
}