module "fanout_infrastructure" {
  source = "../../"

  environment                    = var.environment
  aws_region                     = var.aws_region
  project_name                   = var.project_name
  s3_versioning_enabled          = var.s3_versioning_enabled
  enable_logging                 = var.enable_logging
  src_account                    = var.src_account 
  sqs_message_retention_seconds  = var.sqs_message_retention_seconds
  sqs_visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
}
