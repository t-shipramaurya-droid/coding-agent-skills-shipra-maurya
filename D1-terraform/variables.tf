variable "project_name" {
  description = "Prefix for resource names"
  type        = string
  default     = "pm4-6558-convert"
}

variable "environment" {
  description = "Deployment environment label"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key (use 'test' for LocalStack)"
  type        = string
  default     = "test"
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key (use 'test' for LocalStack)"
  type        = string
  default     = "test"
  sensitive   = true
}

variable "use_localstack" {
  description = "When true, skip AWS credential checks and use LocalStack endpoints"
  type        = bool
  default     = true
}

variable "localstack_endpoint" {
  description = "LocalStack gateway URL"
  type        = string
  default     = "http://localhost:4566"
}

variable "lambda_runtime" {
  description = "Python runtime for the convert Lambda"
  type        = string
  default     = "python3.11"
}
