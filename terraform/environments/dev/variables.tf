variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "fanout-medallion"
}

variable "s3_versioning_enabled" {
  description = "Enable S3 versioning"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable CloudWatch logging"
  type        = bool
  default     = true
}
variable "src_account" {
  description = "Source AWS account ID for SNS topic policy"
  type        = string
}


variable "sqs_message_retention_seconds" {
  description = "SQS message retention"
  type        = number
  default     = 345600 # 4 days
}

variable "sqs_visibility_timeout_seconds" {
  description = "SQS visibility timeout"
  type        = number
  default     = 300
}
