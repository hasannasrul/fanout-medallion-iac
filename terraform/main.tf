# ==================== S3 BUCKETS ====================
module "s3_buckets_bronze" {
  source = "./modules/s3"

  layer        = "bronze"
  environment  = var.environment
  project_name = var.project_name

  versioning_enabled = var.s3_versioning_enabled
  enable_logging     = var.enable_logging
}

module "s3_buckets_silver" {
  source = "./modules/s3"

  layer        = "silver"
  environment  = var.environment
  project_name = var.project_name

  versioning_enabled = var.s3_versioning_enabled
  enable_logging     = var.enable_logging
}

module "s3_buckets_gold" {
  source = "./modules/s3"

  layer        = "gold"
  environment  = var.environment
  project_name = var.project_name

  versioning_enabled = var.s3_versioning_enabled
  enable_logging     = var.enable_logging
}

# # ==================== SNS TOPICS ====================
module "sns_topics_bronze" {
  source = "./modules/sns"

  environment    = var.environment
  project_name   = var.project_name
  layer          = "bronze"
  src_account    = var.src_account
  src_bucket_arn = module.s3_buckets_bronze.bucket_arn
}

module "sns_topics_silver" {
  source = "./modules/sns"

  environment    = var.environment
  project_name   = var.project_name
  layer          = "silver"
  src_account    = var.src_account
  src_bucket_arn = module.s3_buckets_silver.bucket_arn
}

module "sns_topics_gold" {
  source = "./modules/sns"

  environment    = var.environment
  project_name   = var.project_name
  layer          = "gold"
  src_account    = var.src_account
  src_bucket_arn = module.s3_buckets_gold.bucket_arn
}

# ==================== S3 EVENT NOTIFICATIONS → SNS ====================

# S3 Event Notifications publish to SNS topics
resource "aws_s3_bucket_notification" "bronze_notification" {
  bucket = module.s3_buckets_bronze.bucket_id
  topic {
    topic_arn     = module.sns_topics_bronze.topic_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "data/"
  }

    depends_on = [module.sns_topics_bronze]
}

resource "aws_s3_bucket_notification" "silver_notification" {
  bucket = module.s3_buckets_silver.bucket_id

  topic {
    topic_arn     = module.sns_topics_silver.topic_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = ""
  }

    depends_on = [module.sns_topics_silver]
}

resource "aws_s3_bucket_notification" "gold_notification" {
  bucket = module.s3_buckets_gold.bucket_id

  topic {
    topic_arn     = module.sns_topics_gold.topic_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = ""
  }

    depends_on = [module.sns_topics_gold]
}


# ==================== SQS QUEUES ====================

module "sqs_queue_bronze" {
  source = "./modules/sqs"

  environment  = var.environment
  project_name = var.project_name
  layer        = "bronze"

  message_retention_seconds  = var.sqs_message_retention_seconds
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
}

module "sqs_queue_silver" {
  source = "./modules/sqs"

  environment  = var.environment
  project_name = var.project_name
  layer        = "silver"

  message_retention_seconds  = var.sqs_message_retention_seconds
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
}

module "sqs_queue_gold" {
  source = "./modules/sqs"

  environment  = var.environment
  project_name = var.project_name
  layer        = "gold"

  message_retention_seconds  = var.sqs_message_retention_seconds
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
}

# ==================== SNS → SQS SUBSCRIPTIONS ====================

# Subscribe Bronze SQS to Bronze SNS topic
resource "aws_sns_topic_subscription" "bronze_sqs" {
  topic_arn            = module.sns_topics_bronze.topic_arn
  protocol             = "sqs"
  endpoint             = module.sqs_queue_bronze.sqs_arn
  raw_message_delivery = true
}

# Subscribe Silver SQS to Silver SNS topic
resource "aws_sns_topic_subscription" "silver_sqs" {
  topic_arn            = module.sns_topics_silver.topic_arn
  protocol             = "sqs"
  endpoint             = module.sqs_queue_silver.sqs_arn
  raw_message_delivery = true
}

# Subscribe Gold SQS to Gold SNS topic
resource "aws_sns_topic_subscription" "gold_sqs" {
  topic_arn            = module.sns_topics_gold.topic_arn
  protocol             = "sqs"
  endpoint             = module.sqs_queue_gold.sqs_arn
  raw_message_delivery = true
}

# # ==================== SQS QUEUE POLICIES FOR SNS PUBLISHING ====================

# # SQS Queue Policies to allow SNS SendMessage
resource "aws_sqs_queue_policy" "bronze_sqs_policy" {
  queue_url = module.sqs_queue_bronze.sqs_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = module.sqs_queue_bronze.sqs_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.sns_topics_bronze.topic_arn
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "silver_sqs_policy" {
  queue_url = module.sqs_queue_silver.sqs_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = module.sqs_queue_silver.sqs_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.sns_topics_silver.topic_arn
          }
        }
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "gold_sqs_policy" {
  queue_url = module.sqs_queue_gold.sqs_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = module.sqs_queue_gold.sqs_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = module.sns_topics_gold.topic_arn
          }
        }
      }
    ]
  })
}


