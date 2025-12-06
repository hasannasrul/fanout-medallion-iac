variable "project_name" { type = string }
variable "environment"  { type = string }
variable "layer"        { type = string }

variable "s3_bucket" {
  type        = string
  description = "Bucket where Lambda zip is stored"
}

variable "s3_key" {
  type        = string
  description = "Key/path to Lambda zip"
}

variable "lambda_handler" {
  type    = string
  default = "app.handler"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.12"
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "lambda_timeout" {
  type    = number
  default = 30
}

variable "lambda_memory_size" {
  type    = number
  default = 128
}
