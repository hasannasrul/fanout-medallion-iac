output "sqs_url" {
  description = "SQS queue URL"
  value       = aws_sqs_queue.this.url
}

output "sqs_arn" {
  description = "SQS queue ARN"
  value       = aws_sqs_queue.this.arn
}
