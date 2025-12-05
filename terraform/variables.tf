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

variable "rds_engine" {
  description = "RDS database engine"
  type        = string
  default     = "postgres"
  validation {
    condition     = contains(["postgres", "mysql"], var.rds_engine)
    error_message = "RDS engine must be postgres or mysql."
  }
}

variable "rds_instance_class" {
  description = "RDS instance class (free tier: db.t3.micro or db.t2.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_database_name" {
  description = "RDS database name"
  type        = string
  default     = "analytics"
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB (free tier: 20GB)"
  type        = number
  default     = 20
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
