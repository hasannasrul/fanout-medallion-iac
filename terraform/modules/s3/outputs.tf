output "bronze_bucket_id" {
  description = "Bronze S3 bucket name"
  value       = aws_s3_bucket.bronze.id
}

output "bronze_bucket_arn" {
  description = "Bronze S3 bucket ARN"
  value       = aws_s3_bucket.bronze.arn
}

output "silver_bucket_id" {
  description = "Silver S3 bucket name"
  value       = aws_s3_bucket.silver.id
}

output "silver_bucket_arn" {
  description = "Silver S3 bucket ARN"
  value       = aws_s3_bucket.silver.arn
}

output "gold_bucket_id" {
  description = "Gold S3 bucket name"
  value       = aws_s3_bucket.gold.id
}

output "gold_bucket_arn" {
  description = "Gold S3 bucket ARN"
  value       = aws_s3_bucket.gold.arn
}
