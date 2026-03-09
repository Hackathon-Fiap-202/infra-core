output "endpoint" {
  description = "DocumentDB cluster endpoint"
  value       = aws_docdb_cluster.this.endpoint
}

output "reader_endpoint" {
  description = "DocumentDB cluster reader endpoint"
  value       = aws_docdb_cluster.this.reader_endpoint
}

output "port" {
  description = "DocumentDB port"
  value       = aws_docdb_cluster.this.port
}

output "security_group_id" {
  description = "Security group ID for DocumentDB"
  value       = aws_security_group.docdb.id
}

output "secret_arn" {
  description = "ARN of Secrets Manager secret with DocumentDB credentials"
  value       = aws_secretsmanager_secret.docdb_credentials.arn
}

output "connection_string" {
  description = "MongoDB connection string (without password)"
  value       = "mongodb://${var.master_username}:***@${aws_docdb_cluster.this.endpoint}:27017/?authSource=admin&tls=false"
  sensitive   = true
}
