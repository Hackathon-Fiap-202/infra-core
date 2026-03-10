variable "api_key" {
  description = "Datadog API key — injected at plan time via GitHub Secret DATADOG_API_KEY; never stored in code"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags applied to all resources in this module"
  type        = map(string)
  default     = {}
}
