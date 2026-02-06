variable "nat_name" {
  type        = string
  description = "Nome do NAT Gateway"
  default = ""
}

variable "public_subnet_id" {
  type        = string
  description = "Subnet pública onde o NAT será criado"
}

variable "tags" {
  type    = map(string)
  default = {}
}
