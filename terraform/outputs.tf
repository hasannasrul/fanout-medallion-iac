output "bronze_bucket_name" {
  description = "Bronze S3 bucket name"
  value       = module.s3_buckets_bronze.bucket_id
}

output "silver_bucket_name" {
  description = "Silver S3 bucket name"
  value       = module.s3_buckets_silver.bucket_id
}

output "gold_bucket_name" {
  description = "Gold S3 bucket name"
  value       = module.s3_buckets_gold.bucket_id
}

# # ==================== SNS TOPIC OUTPUTS ====================

output "bronze_sns_topic_arn" {
  description = "Bronze SNS topic ARN"
  value       = module.sns_topics_bronze.topic_arn
}

output "silver_sns_topic_arn" {
  description = "Silver SNS topic ARN"
  value       = module.sns_topics_silver.topic_arn
}

output "gold_sns_topic_arn" {
  description = "Gold SNS topic ARN"
  value       = module.sns_topics_gold.topic_arn
}

output "bronze_sqs_queue_url" {
  description = "Bronze SQS queue URL"
  value       = module.sqs_queue_bronze.sqs_url
}

output "silver_sqs_queue_url" {
  description = "Silver SQS queue URL"
  value       = module.sqs_queue_silver.sqs_url
}

output "gold_sqs_queue_url" {
  description = "Gold SQS queue URL"
  value       = module.sqs_queue_gold.sqs_url
}

