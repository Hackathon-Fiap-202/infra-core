variable "bucket_state_name" {
  description = "Nome do bucket S3 para armazenar o state"
  type        = string
  default     = "nextime-frame-state-bucket-s3"
}

variable "environment" {
  description = "Ambiente de deploy"
  type        = string
  default     = "prod"
}
