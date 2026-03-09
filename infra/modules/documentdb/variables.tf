variable "cluster_identifier" {
  description = "DocumentDB cluster identifier"
  type        = string
}

variable "master_username" {
  description = "Master username"
  type        = string
  default     = "nexadmin"
}

variable "master_password" {
  description = "Master password (stored in Secrets Manager)"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "DocumentDB instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "instance_count" {
  description = "Number of DocumentDB instances"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "Subnet IDs for DocumentDB subnet group (private subnets)"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allowed_security_group_id" {
  description = "Security Group ID of ECS tasks that need access to DocumentDB"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
