locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = "PM4-6558"
    Exercise    = "D1-terraform"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/.build/lambda.zip"
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "${local.name_prefix}-artifacts"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-artifacts"
  })
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.name_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "convert" {
  function_name = "${local.name_prefix}-convert"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "handler.lambda_handler"
  runtime       = var.lambda_runtime
  timeout       = 10

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-convert"
  })
}

resource "aws_apigatewayv2_api" "convert" {
  name          = "${local.name_prefix}-api"
  protocol_type = "HTTP"
  description   = "Currency convert API (PM4-6558 D1)"

  tags = local.common_tags
}

resource "aws_apigatewayv2_integration" "convert" {
  api_id                 = aws_apigatewayv2_api.convert.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.convert.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "convert_post" {
  api_id    = aws_apigatewayv2_api.convert.id
  route_key = "POST /convert"
  target    = "integrations/${aws_apigatewayv2_integration.convert.id}"
}

resource "aws_apigatewayv2_route" "health_get" {
  api_id    = aws_apigatewayv2_api.convert.id
  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.convert.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.convert.id
  name        = "$default"
  auto_deploy = true

  tags = local.common_tags
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.convert.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.convert.execution_arn}/*/*"
}
