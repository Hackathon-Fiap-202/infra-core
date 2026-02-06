variable "acl_name" {
  type        = string
  description = "Nome do ACL"
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC"
  default = ""
}

variable "subnet_id" {
  type        = string
  description = "ID da subnet associada"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags aplicadas ao ACL"
}