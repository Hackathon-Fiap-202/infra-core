variable "cluster_identifier" {
  description = "Identifier used as prefix for the Secrets Manager secret name"
  type        = string
}

variable "mongo_uri" {
  description = "MongoDB Atlas connection URI (stored in Secrets Manager)"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
