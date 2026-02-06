variable "sg_api_name" {
  type        = string
  description = "Nome do SG da API"
  default = ""
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas ao SG"
}
