resource "aws_security_group" "this" {
  name        = var.sg_api_name
  description = "Security group para a API"
  vpc_id      = var.vpc_id

  ingress {
    description = "Permitir acesso HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Permitir acesso HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = var.sg_api_name
    },
    var.tags
  )
}
