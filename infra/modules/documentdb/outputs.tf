output "secret_arn" {
  description = "ARN of Secrets Manager secret containing the MongoDB Atlas URI"
  value       = aws_secretsmanager_secret.docdb_credentials.arn
}
