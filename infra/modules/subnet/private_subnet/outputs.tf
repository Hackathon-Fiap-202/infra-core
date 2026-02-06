output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "subnet_group_name" {
  value = var.subnet_group_name
}