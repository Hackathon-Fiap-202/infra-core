variable "name" {
  description = "API Gateway Tech challenge"
  type        = string
}

variable "description" {
  description = "Descrição do API Gateway"
  type        = string
  default     = "API Gateway gerenciado pelo Terraform"
}

variable "root_path" {
  description = "Path raiz do recurso do API Gateway"
  type        = string
  default     = "items"
}

variable "stage_name" {
  description = "Nome do stage para o deployment"
  type        = string
  default     = "dev"
}
