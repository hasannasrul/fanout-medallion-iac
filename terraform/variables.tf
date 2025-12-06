variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "fanout-medallion"
}

variable "s3_versioning_enabled" {
  description = "Enable versioning on S3 buckets"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable logging for monitoring"
  type        = bool
  default     = true
}

variable "enable_public_read" {
  description = "Enable public read access to config bucket (NOT recommended for production)"
  type        = bool
  default     = false
}

variable "src_account" {
  description = "Source AWS account ID for SNS topic policy"
  type        = string

}

variable "sqs_message_retention_seconds" {
  description = "SQS message retention in seconds (free tier eligible)"
  type        = number
  default     = 345600 # 4 days to stay within free tier
}

variable "sqs_visibility_timeout_seconds" {
  description = "SQS visibility timeout in seconds"
  type        = number
  default     = 300
}

