resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.route_cidr
    gateway_id = var.gateway_id
  }

  tags = merge(
    {
      Name = var.route_table_name
    },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}