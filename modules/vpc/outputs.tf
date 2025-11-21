# 作成したVPC ID をモジュールの外部に渡す
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "作成されたVPCのID"
}

# 作成したパブリックサブネット
output "public_subnet_ids" {
  description = "パブリックサブネットID"
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

# 作成したプライベートサブネット
output "private_subnet_ids" {
  description = "プライベートサブネットID"
  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}