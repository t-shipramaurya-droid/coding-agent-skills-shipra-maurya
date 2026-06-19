output "s3_bucket_name" {
  description = "S3 bucket for deployment artifacts"
  value       = aws_s3_bucket.artifacts.bucket
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.convert.function_name
}

output "api_gateway_endpoint" {
  description = "HTTP API invoke URL (append route path, e.g. /health)"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "convert_url" {
  description = "Full POST /convert URL"
  value       = "${aws_apigatewayv2_stage.default.invoke_url}convert"
}

output "health_url" {
  description = "Full GET /health URL"
  value       = "${aws_apigatewayv2_stage.default.invoke_url}health"
}
