resource "aws_s3_bucket" "bronze" {
  bucket = "${var.project_name}-bronze-${var.environment}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Layer = "Bronze"
    Name  = "${var.project_name}-bronze"
  }
}

resource "aws_s3_bucket_versioning" "bronze" {
  bucket = aws_s3_bucket.bronze.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "bronze" {
  bucket = aws_s3_bucket.bronze.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bronze" {
  bucket = aws_s3_bucket.bronze.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Silver Bucket (intermediate data)
resource "aws_s3_bucket" "silver" {
  bucket = "${var.project_name}-silver-${var.environment}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Layer = "Silver"
    Name  = "${var.project_name}-silver"
  }
}

resource "aws_s3_bucket_versioning" "silver" {
  bucket = aws_s3_bucket.silver.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "silver" {
  bucket = aws_s3_bucket.silver.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "silver" {
  bucket = aws_s3_bucket.silver.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Gold Bucket (curated data)
resource "aws_s3_bucket" "gold" {
  bucket = "${var.project_name}-gold-${var.environment}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Layer = "Gold"
    Name  = "${var.project_name}-gold"
  }
}

resource "aws_s3_bucket_versioning" "gold" {
  bucket = aws_s3_bucket.gold.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "gold" {
  bucket = aws_s3_bucket.gold.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "gold" {
  bucket = aws_s3_bucket.gold.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle policies to manage costs (free tier friendly)
resource "aws_s3_bucket_lifecycle_configuration" "bronze" {
  count  = var.versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.bronze.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "silver" {
  count  = var.versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.silver.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "gold" {
  count  = var.versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.gold.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}
