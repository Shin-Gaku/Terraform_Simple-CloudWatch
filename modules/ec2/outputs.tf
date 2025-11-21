# 作成したEC2インスタンスIDをモジュール外に渡す
output "instance_id" {
  value = aws_instance.ec2.id
}

# 作成したEC2インスタンスIPをモジュール外に渡す
output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}

# 作成したEC2のSGをRDS用に渡す
output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}