# Bronze SQS Queue - triggered by bronze bucket uploads
resource "aws_sqs_queue" "bronze" {
  name                      = "${var.project_name}-bronze-queue-${var.environment}"
  message_retention_seconds = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds = 20 # Long polling

  tags = {
    Layer = "Bronze"
    Name  = "${var.project_name}-bronze-queue"
  }
}

# Silver SQS Queue - triggered by silver bucket uploads
resource "aws_sqs_queue" "silver" {
  name                       = "${var.project_name}-silver-queue-${var.environment}"
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = 20 # Long polling

  tags = {
    Layer = "Silver"
    Name  = "${var.project_name}-silver-queue"
  }
}

# Gold SQS Queue - triggered by gold bucket uploads (for RDS database copy)
resource "aws_sqs_queue" "gold" {
  name                       = "${var.project_name}-gold-queue-${var.environment}"
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = 20 # Long polling

  tags = {
    Layer = "Gold"
    Name  = "${var.project_name}-gold-queue"
  }
}
