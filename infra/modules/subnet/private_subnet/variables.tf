variable "subnet_name" {
  type        = string
  description = "Prefixo para nome das subnets"
}

variable "subnet_group_name" {
  type        = string
  description = "Nome para o grupo nome das subnets"
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "azs" {
  type        = list(string)
  description = "Zonas de disponibilidade"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDRs das subnets privadas"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas às subnets"
}