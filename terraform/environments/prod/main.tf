module "fanout_infrastructure" {
  source = "../../"

  environment                    = var.environment
  aws_region                     = var.aws_region
  project_name                   = var.project_name
  rds_engine                     = var.rds_engine
  rds_instance_class             = var.rds_instance_class
  rds_database_name              = var.rds_database_name
  rds_username                   = var.rds_username
  rds_password                   = var.rds_password
  rds_allocated_storage          = var.rds_allocated_storage
  s3_versioning_enabled          = var.s3_versioning_enabled
  enable_logging                 = var.enable_logging
  lambda_timeout                 = var.lambda_timeout
  lambda_memory                  = var.lambda_memory
  sqs_message_retention_seconds  = var.sqs_message_retention_seconds
  sqs_visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
}
