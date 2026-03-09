# Security Group for DocumentDB — only accepts connections from ECS tasks
resource "aws_security_group" "docdb" {
  name        = "${var.cluster_identifier}-sg"
  description = "Security group for DocumentDB cluster"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MongoDB from ECS tasks"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [var.allowed_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "${var.cluster_identifier}-sg" }, var.tags)
}

# Subnet group using private subnets
resource "aws_docdb_subnet_group" "this" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge({ Name = "${var.cluster_identifier}-subnet-group" }, var.tags)
}

# Cluster parameter group (TLS optional — disable for dev simplicity)
resource "aws_docdb_cluster_parameter_group" "this" {
  family      = "docdb5.0"
  name        = "${var.cluster_identifier}-params"
  description = "DocumentDB cluster parameter group"

  parameter {
    name  = "tls"
    value = "disabled"
  }

  tags = var.tags
}

# DocumentDB cluster
resource "aws_docdb_cluster" "this" {
  cluster_identifier              = var.cluster_identifier
  engine                          = "docdb"
  master_username                 = var.master_username
  master_password                 = var.master_password
  db_subnet_group_name            = aws_docdb_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.docdb.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.name
  skip_final_snapshot             = true
  deletion_protection             = false

  tags = merge({ Name = var.cluster_identifier }, var.tags)
}

# DocumentDB instance(s)
resource "aws_docdb_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class

  tags = merge({ Name = "${var.cluster_identifier}-instance-${count.index}" }, var.tags)
}

# Store credentials in Secrets Manager
resource "aws_secretsmanager_secret" "docdb_credentials" {
  name                    = "${var.cluster_identifier}/credentials"
  recovery_window_in_days = 0

  tags = merge({ Name = "${var.cluster_identifier}/credentials" }, var.tags)
}

resource "aws_secretsmanager_secret_version" "docdb_credentials" {
  secret_id = aws_secretsmanager_secret.docdb_credentials.id
  secret_string = jsonencode({
    username  = var.master_username
    password  = var.master_password
    host      = aws_docdb_cluster.this.endpoint
    port      = 27017
    mongo_uri = "mongodb://${var.master_username}:${var.master_password}@${aws_docdb_cluster.this.endpoint}:27017/msvideo?authSource=admin&tls=false"
  })
}
