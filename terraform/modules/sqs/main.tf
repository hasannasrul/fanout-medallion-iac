# Bronze SQS Queue - triggered by bronze bucket uploads
resource "aws_sqs_queue" "this" {
  name                      = "${var.project_name}-${var.layer}-queue-${var.environment}"
  message_retention_seconds = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds = 20 # Long polling

  tags = {
    Layer = var.layer
    Name  = "${var.project_name}-${var.layer}-queue"
  }
}