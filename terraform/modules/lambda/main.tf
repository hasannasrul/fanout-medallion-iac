# Lambda execution role
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.layer}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Basic execution policy
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "this" {
  function_name = "${var.project_name}-${var.layer}-${var.environment}-processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  source_code_hash = data.aws_s3_object.lambda_hash.version_id

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  environment {
    variables = var.env_vars
  }
}

data "aws_s3_object" "lambda_hash" {
  bucket = var.s3_bucket
  key    = var.s3_key
}