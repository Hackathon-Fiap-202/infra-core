# Store MongoDB Atlas URI in Secrets Manager
resource "aws_secretsmanager_secret" "docdb_credentials" {
  name                    = "${var.cluster_identifier}/credentials"
  recovery_window_in_days = 0

  tags = merge({ Name = "${var.cluster_identifier}/credentials" }, var.tags)
}

resource "aws_secretsmanager_secret_version" "docdb_credentials" {
  secret_id     = aws_secretsmanager_secret.docdb_credentials.id
  secret_string = jsonencode({ mongo_uri = var.mongo_uri })
}
