# Bronze SNS Topic
resource "aws_sns_topic" "bronze" {
  name              = "${var.project_name}-bronze-topic-${var.environment}"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Layer = "Bronze"
    Name  = "${var.project_name}-bronze-topic"
  }
}

resource "aws_sns_topic_policy" "bronze" {
  arn    = aws_sns_topic.bronze.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.bronze.arn
      }
    ]
  })
}

# Silver SNS Topic
resource "aws_sns_topic" "silver" {
  name              = "${var.project_name}-silver-topic-${var.environment}"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Layer = "Silver"
    Name  = "${var.project_name}-silver-topic"
  }
}

resource "aws_sns_topic_policy" "silver" {
  arn    = aws_sns_topic.silver.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.silver.arn
      }
    ]
  })
}

# Gold SNS Topic
resource "aws_sns_topic" "gold" {
  name              = "${var.project_name}-gold-topic-${var.environment}"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Layer = "Gold"
    Name  = "${var.project_name}-gold-topic"
  }
}

resource "aws_sns_topic_policy" "gold" {
  arn    = aws_sns_topic.gold.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.gold.arn
      }
    ]
  })
}
