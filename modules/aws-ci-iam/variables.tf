variable "env_suffix" {
  description = "The environment suffix for resources naming"
  type        = string
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
