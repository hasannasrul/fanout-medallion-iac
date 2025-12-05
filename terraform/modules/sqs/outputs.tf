output "bronze_sqs_url" {
  description = "Bronze SQS queue URL"
  value       = aws_sqs_queue.bronze.url
}

output "bronze_sqs_arn" {
  description = "Bronze SQS queue ARN"
  value       = aws_sqs_queue.bronze.arn
}

output "silver_sqs_url" {
  description = "Silver SQS queue URL"
  value       = aws_sqs_queue.silver.url
}

output "silver_sqs_arn" {
  description = "Silver SQS queue ARN"
  value       = aws_sqs_queue.silver.arn
}

output "gold_sqs_url" {
  description = "Gold SQS queue URL"
  value       = aws_sqs_queue.gold.url
}

output "gold_sqs_arn" {
  description = "Gold SQS queue ARN"
  value       = aws_sqs_queue.gold.arn
}
