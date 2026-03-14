# ─── Security Group for VPC Interface Endpoints ───────────────────────────────
resource "aws_security_group" "vpc_endpoints" {
  name        = "nextime-frame-vpc-endpoints-sg"
  description = "Allow HTTPS from within the VPC to reach interface endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS from VPC CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "nextime-frame-vpc-endpoints-sg" }, var.tags)
}

# ─── Interface Endpoint: Secrets Manager ─────────────────────────────────────
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.private_subnet.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge({ Name = "nextime-frame-secretsmanager-endpoint" }, var.tags)
}

# ─── Interface Endpoint: ECR API ──────────────────────────────────────────────
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.private_subnet.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge({ Name = "nextime-frame-ecr-api-endpoint" }, var.tags)
}

# ─── Interface Endpoint: ECR DKR (image layers) ───────────────────────────────
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.private_subnet.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge({ Name = "nextime-frame-ecr-dkr-endpoint" }, var.tags)
}

# ─── Interface Endpoint: CloudWatch Logs ─────────────────────────────────────
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.private_subnet.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge({ Name = "nextime-frame-logs-endpoint" }, var.tags)
}

# ─── Gateway Endpoint: S3 (free, no ENI needed) ───────────────────────────────
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [module.route_table_private.route_table_id]

  tags = merge({ Name = "nextime-frame-s3-endpoint" }, var.tags)
}
