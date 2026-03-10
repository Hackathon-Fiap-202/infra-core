variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Lista de IDs das subnets privadas"
}

variable "nat_gateway_id" {
  type        = string
  description = "ID do NAT Gateway para rota de saída"
}

variable "route_table_name" {
  type        = string
  description = "Nome da tabela de rotas privada"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas à route table"
}
