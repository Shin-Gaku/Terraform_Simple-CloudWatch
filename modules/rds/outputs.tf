# 作成したRDSのIDをモジュール外に渡す
output "rds_id" {
  description = "RDSのID"
  value       = aws_db_instance.rds.id
}

# 作成したRDSのSecurity Group ID
output "rds_sg_id" {
  description = "RDS Security Group ID"
  value       = aws_security_group.rds_sg.id
}

# 作成したRDSのSecurity Group ID
output "rds_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.rds.endpoint
}