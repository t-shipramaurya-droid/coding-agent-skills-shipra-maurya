# Offline plan verification using Terraform mock AWS provider (no real AWS / LocalStack required)

mock_provider "aws" {
  alias = "mock"
}

run "plan_is_clean" {
  command = plan

  providers = {
    aws = aws.mock
  }
}
