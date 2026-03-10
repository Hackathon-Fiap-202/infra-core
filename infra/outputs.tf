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

# ECR outputs
output "ecr_repository_urls" {
  description = "Map of ECR repository name to URL"
  value       = module.ecr.repository_urls
}

output "ms_video_ecr_url" {
  description = "ECR URL for ms-video"
  value       = module.ecr.repository_urls["ms-video"]
}

output "process_video_ecr_url" {
  description = "ECR URL for process-video"
  value       = module.ecr.repository_urls["process-video"]
}

output "docdb_secret_arn" {
  description = "ARN of the Secrets Manager secret with MongoDB Atlas URI"
  value       = module.documentdb.secret_arn
}

output "datadog_api_key_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the Datadog API key"
  value       = module.datadog.secret_arn
}
