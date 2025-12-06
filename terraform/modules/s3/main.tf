resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-${var.layer}-${var.environment}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Layer = var.layer
    Name  = "${var.project_name}-${var.layer}"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



# Lifecycle policies to manage costs (free tier friendly)
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.versioning_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id

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
