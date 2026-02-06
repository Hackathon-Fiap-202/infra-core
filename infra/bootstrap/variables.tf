variable "bucket_state_name" {
  description = "Nome do bucket S3 para armazenar o state"
  type        = string
}

variable "environment" {
  description = "Ambiente de deploy"
  type        = string
}
