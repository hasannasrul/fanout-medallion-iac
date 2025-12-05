output "bronze_bucket_name" {
  value = module.fanout_infrastructure.bronze_bucket_name
}

output "silver_bucket_name" {
  value = module.fanout_infrastructure.silver_bucket_name
}

output "gold_bucket_name" {
  value = module.fanout_infrastructure.gold_bucket_name
}

output "bronze_sqs_url" {
  value = module.fanout_infrastructure.bronze_sqs_queue_url
}

output "silver_sqs_url" {
  value = module.fanout_infrastructure.silver_sqs_queue_url
}

output "gold_sqs_url" {
  value = module.fanout_infrastructure.gold_sqs_queue_url
}

output "bronze_lambda_role_arn" {
  value = module.fanout_infrastructure.bronze_lambda_role_arn
}

output "silver_lambda_role_arn" {
  value = module.fanout_infrastructure.silver_lambda_role_arn
}

output "gold_lambda_role_arn" {
  value = module.fanout_infrastructure.gold_lambda_role_arn
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.fanout_infrastructure.rds_endpoint
}

output "rds_address" {
  description = "RDS database address"
  value       = module.fanout_infrastructure.rds_address
}

output "rds_port" {
  description = "RDS database port"
  value       = module.fanout_infrastructure.rds_port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = module.fanout_infrastructure.rds_database_name
}

# ==================== SNS TOPIC OUTPUTS ====================

output "bronze_sns_topic_arn" {
  description = "Bronze SNS topic ARN"
  value       = module.fanout_infrastructure.bronze_sns_topic_arn
}

output "silver_sns_topic_arn" {
  description = "Silver SNS topic ARN"
  value       = module.fanout_infrastructure.silver_sns_topic_arn
}

output "gold_sns_topic_arn" {
  description = "Gold SNS topic ARN"
  value       = module.fanout_infrastructure.gold_sns_topic_arn
}
