resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge({ Name = "${var.subnet_name}-private-${count.index}" }, var.tags)
}