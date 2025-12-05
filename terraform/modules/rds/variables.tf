variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "rds_engine" {
  description = "RDS database engine"
  type        = string
  default     = "postgres"
}

variable "rds_instance_class" {
  description = "RDS instance class (free tier eligible)"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_database_name" {
  description = "Database name"
  type        = string
  default     = "analytics"
}

variable "rds_username" {
  description = "Master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "rds_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "rds_allocated_storage" {
  description = "Allocated storage in GB (free tier: 20GB)"
  type        = number
  default     = 20
}
