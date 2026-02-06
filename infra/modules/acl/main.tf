resource "aws_network_acl" "this" {
  vpc_id = var.vpc_id
  tags   = merge({ Name = var.acl_name }, var.tags)
}

resource "aws_network_acl_rule" "allow_http" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "allow_https" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "allow_all_egress" {
  network_acl_id = aws_network_acl.this.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_association" "this" {
  network_acl_id = aws_network_acl.this.id
  subnet_id      = var.subnet_id
}
