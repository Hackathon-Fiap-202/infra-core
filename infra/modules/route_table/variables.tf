variable "vpc_id" {
  type        = string
  description = "ID da VPC"
  default = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "Lista de IDs das subnets"
}

variable "gateway_id" {
  type        = string
  description = "ID do Internet Gateway"
}

variable "route_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR para rota padrão"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas à route table"
}

variable "route_table_name" {
  description = "Nome da Tabela de Rotas."
  type        = string
}