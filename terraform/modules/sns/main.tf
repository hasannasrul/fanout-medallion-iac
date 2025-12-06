# Bronze SNS Topic
resource "aws_sns_topic" "this" {
  name              = "${var.project_name}-${var.layer}-topic-${var.environment}"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Layer = var.layer
    Name  = "${var.project_name}-${var.layer}-topic-${var.environment}"
  }
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.this.arn,
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": var.src_account,
          "aws:SourceArn": var.src_bucket_arn
        }
      }
      }
    ]
  })
}
