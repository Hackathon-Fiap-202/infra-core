output "secret_arn" {
  description = "ARN of the Secrets Manager secret containing the Datadog API key"
  value       = aws_secretsmanager_secret.datadog_api_key.arn
}
