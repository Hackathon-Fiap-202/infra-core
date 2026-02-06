output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas"
  value       = module.public_subnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas"
  value       = module.private_subnet.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = module.internet_gateway.igw_id
}

output "route_table_id" {
  description = "ID da Route Table"
  value       = module.route_table.route_table_id
}

output "security_group_api_id" {
  description = "ID do Security Group da API"
  value       = module.security_group_api.security_group_id
}

output "network_acl_id" {
  description = "ID do Network ACL"
  value       = module.acl.acl_id
}