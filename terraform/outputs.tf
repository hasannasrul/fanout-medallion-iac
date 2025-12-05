output "bronze_bucket_name" {
  description = "Bronze S3 bucket name"
  value       = module.s3_buckets.bronze_bucket_id
}

output "silver_bucket_name" {
  description = "Silver S3 bucket name"
  value       = module.s3_buckets.silver_bucket_id
}

output "gold_bucket_name" {
  description = "Gold S3 bucket name"
  value       = module.s3_buckets.gold_bucket_id
}

output "bronze_sqs_queue_url" {
  description = "Bronze SQS queue URL"
  value       = module.sqs_queues.bronze_sqs_url
}

output "silver_sqs_queue_url" {
  description = "Silver SQS queue URL"
  value       = module.sqs_queues.silver_sqs_url
}

output "gold_sqs_queue_url" {
  description = "Gold SQS queue URL"
  value       = module.sqs_queues.gold_sqs_url
}

# ==================== SNS TOPIC OUTPUTS ====================

output "bronze_sns_topic_arn" {
  description = "Bronze SNS topic ARN"
  value       = module.sns_topics.bronze_topic_arn
}

output "silver_sns_topic_arn" {
  description = "Silver SNS topic ARN"
  value       = module.sns_topics.silver_topic_arn
}

output "gold_sns_topic_arn" {
  description = "Gold SNS topic ARN"
  value       = module.sns_topics.gold_topic_arn
}


output "rds_endpoint" {
  description = "RDS database endpoint (address:port)"
  value       = module.rds_database.rds_endpoint
}

output "rds_address" {
  description = "RDS database address"
  value       = module.rds_database.rds_address
}

output "rds_port" {
  description = "RDS database port"
  value       = module.rds_database.rds_port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = module.rds_database.rds_database_name
}

output "rds_db_instance_id" {
  description = "RDS instance identifier"
  value       = module.rds_database.db_instance_id
}
