
module "s3_buckets" {
  source = "./modules/s3"

  environment = var.environment
  project_name = var.project_name
  
  versioning_enabled = var.s3_versioning_enabled
  enable_logging     = var.enable_logging
}

module "sns_topics" {
  source = "./modules/sns"

  environment  = var.environment
  project_name = var.project_name
}

module "sqs_queues" {
  source = "./modules/sqs"

  environment = var.environment
  project_name = var.project_name
  
  message_retention_seconds    = var.sqs_message_retention_seconds
  visibility_timeout_seconds   = var.sqs_visibility_timeout_seconds
}

module "rds_database" {
  source = "./modules/rds"

  environment           = var.environment
  project_name          = var.project_name
  rds_engine            = var.rds_engine
  rds_instance_class    = var.rds_instance_class
  rds_database_name     = var.rds_database_name
  rds_username          = var.rds_username
  rds_password          = var.rds_password
  rds_allocated_storage = var.rds_allocated_storage
}

module "security_groups" {
  source = "./modules/security"

  environment = var.environment
  project_name = var.project_name
  
  # VPC configuration will be passed from environment
}

# ==================== S3 EVENT NOTIFICATIONS → SNS ====================

# S3 Event Notifications publish to SNS topics
resource "aws_s3_bucket_notification" "bronze_notification" {
  bucket = module.s3_buckets.bronze_bucket_id

  topic {
    topic_arn     = module.sns_topics.bronze_topic_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = ""
  }

  depends_on = [aws_sns_topic_policy.bronze_s3_publish]
}

resource "aws_s3_bucket_notification" "silver_notification" {
  bucket = module.s3_buckets.silver_bucket_id

  topic {
    topic_arn     = module.sns_topics.silver_topic_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = ""
  }

  depends_on = [aws_sns_topic_policy.silver_s3_publish]
}

resource "aws_s3_bucket_notification" "gold_notification" {
  bucket = module.s3_buckets.gold_bucket_id

  topic {
    topic_arn     = module.sns_topics.gold_topic_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = ""
  }

  depends_on = [aws_sns_topic_policy.gold_s3_publish]
}

# ==================== SNS TOPIC POLICIES FOR S3 PUBLISHING ====================

resource "aws_sns_topic_policy" "bronze_s3_publish" {
  arn    = module.sns_topics.bronze_topic_arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = module.sns_topics.bronze_topic_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.s3_buckets.bronze_bucket_arn
          }
        }
      }
    ]
  })
}

resource "aws_sns_topic_policy" "silver_s3_publish" {
  arn    = module.sns_topics.silver_topic_arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = module.sns_topics.silver_topic_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.s3_buckets.silver_bucket_arn
          }
        }
      }
    ]
  })
}

resource "aws_sns_topic_policy" "gold_s3_publish" {
  arn    = module.sns_topics.gold_topic_arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = module.sns_topics.gold_topic_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.s3_buckets.gold_bucket_arn
          }
        }
      }
    ]
  })
}

# ==================== SNS → SQS SUBSCRIPTIONS ====================

# Subscribe Bronze SQS to Bronze SNS topic
resource "aws_sns_topic_subscription" "bronze_sqs" {
  topic_arn            = module.sns_topics.bronze_topic_arn
  protocol             = "sqs"
  endpoint             = module.sqs_queues.bronze_sqs_arn
  raw_message_delivery = true
}

# Subscribe Silver SQS to Silver SNS topic
resource "aws_sns_topic_subscription" "silver_sqs" {
  topic_arn            = module.sns_topics.silver_topic_arn
  protocol             = "sqs"
  endpoint             = module.sqs_queues.silver_sqs_arn
  raw_message_delivery = true
}

# Subscribe Gold SQS to Gold SNS topic
resource "aws_sns_topic_subscription" "gold_sqs" {
  topic_arn            = module.sns_topics.gold_topic_arn
  protocol             = "sqs"
  endpoint             = module.sqs_queues.gold_sqs_arn
  raw_message_delivery = true
}

# ==================== SQS QUEUE POLICIES FOR SNS PUBLISHING ====================

# SQS Queue Policies to allow SNS SendMessage
resource "aws_sqs_queue_policy" "bronze_sqs_policy" {
  queue_url = module.sqs_queues.bronze_sqs_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = module.sqs_queues.bronze_sqs_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.sns_topics.bronze_topic_arn
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "silver_sqs_policy" {
  queue_url = module.sqs_queues.silver_sqs_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = module.sqs_queues.silver_sqs_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.sns_topics.silver_topic_arn
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "gold_sqs_policy" {
  queue_url = module.sqs_queues.gold_sqs_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = module.sqs_queues.gold_sqs_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.sns_topics.gold_topic_arn
          }
        }
      }
    ]
  })
}
