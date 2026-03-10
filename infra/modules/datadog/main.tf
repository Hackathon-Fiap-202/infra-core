# Store the Datadog API key as a plain-text secret in Secrets Manager.
# The value is the raw API key string (not a JSON envelope) so the Datadog
# agent sidecar can reference it directly via the ECS secrets: block and
# the FireLens awsfirelens log driver can read it with secret_string.
resource "aws_secretsmanager_secret" "datadog_api_key" {
  name = "datadog-api-key"

  # Allow immediate deletion/recreation during destroy (no recovery window).
  recovery_window_in_days = 0

  tags = merge({ Name = "datadog-api-key" }, var.tags)
}

resource "aws_secretsmanager_secret_version" "datadog_api_key" {
  secret_id     = aws_secretsmanager_secret.datadog_api_key.id
  secret_string = var.api_key
}
