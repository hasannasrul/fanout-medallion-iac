output "bronze_topic_arn" {
  description = "Bronze SNS topic ARN"
  value       = aws_sns_topic.bronze.arn
}

output "silver_topic_arn" {
  description = "Silver SNS topic ARN"
  value       = aws_sns_topic.silver.arn
}

output "gold_topic_arn" {
  description = "Gold SNS topic ARN"
  value       = aws_sns_topic.gold.arn
}

output "bronze_topic_name" {
  description = "Bronze SNS topic name"
  value       = aws_sns_topic.bronze.name
}

output "silver_topic_name" {
  description = "Silver SNS topic name"
  value       = aws_sns_topic.silver.name
}

output "gold_topic_name" {
  description = "Gold SNS topic name"
  value       = aws_sns_topic.gold.name
}
