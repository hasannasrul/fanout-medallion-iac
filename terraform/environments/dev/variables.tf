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

# variable "rds_engine" {
#   description = "RDS database engine"
#   type        = string
#   default     = "postgres"
# }

# variable "rds_instance_class" {
#   description = "RDS instance class (free tier)"
#   type        = string
#   default     = "db.t3.micro"
# }

# variable "rds_database_name" {
#   description = "RDS database name"
#   type        = string
#   default     = "analytics"
# }

# variable "rds_username" {
#   description = "RDS master username"
#   type        = string
#   default     = "admin"
#   sensitive   = true
# }

# variable "rds_password" {
#   description = "RDS master password"
#   type        = string
#   sensitive   = true
# }

# variable "rds_allocated_storage" {
#   description = "RDS allocated storage (20GB free tier)"
#   type        = number
#   default     = 20
# }

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
