variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "layer" {
  description = "Layer name (e.g., bronze, silver, gold)"
  type        = string
}

variable "src_account" {
  description = "Source AWS account ID"
  type        = string
}

variable "src_bucket_arn" {
  description = "Source S3 bucket ARN"
  type        = string
}
