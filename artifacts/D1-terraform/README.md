# D1 — Terraform (S3 + Lambda + API Gateway)

Terraform for the **I4 currency convert** service on AWS: S3 artifacts bucket, Python Lambda, HTTP API Gateway (`POST /convert`, `GET /health`).

## Prerequisites

- Terraform >= 1.6 (`terraform` or `/tmp/terraform` from HashiCorp release)
- **No real AWS required** for verify — uses mock provider test + local backend
- **Optional:** Docker + LocalStack for real `apply` against `localhost:4566`

## Quick verify (assignment proof)

```bash
cd PM4-6558-assignment/artifacts/D1-terraform
chmod +x scripts/tf-verify.sh
./scripts/tf-verify.sh
```

Or step by step:

```bash
terraform init -input=false
terraform validate
terraform test          # mock AWS — offline plan
terraform plan -out=tfplan
```

## Apply (optional — needs LocalStack or AWS)

### LocalStack (Docker)

```bash
docker run --rm -d -p 4566:4566 localstack/localstack
terraform apply tfplan
terraform output health_url
curl "$(terraform output -raw health_url)"
```

### Real AWS

```bash
terraform apply -var="use_localstack=false" \
  -var="aws_access_key=$AWS_ACCESS_KEY_ID" \
  -var="aws_secret_key=$AWS_SECRET_ACCESS_KEY"
```

## Destroy

```bash
terraform destroy
```

## Layout

| File | Purpose |
|------|---------|
| `versions.tf` | Providers, **local** backend |
| `variables.tf` | Region, LocalStack toggle, naming |
| `main.tf` | S3, IAM, Lambda, API Gateway v2 |
| `outputs.tf` | API URLs, bucket name |
| `lambda/handler.py` | Convert + health handler |
| `tests/main.tftest.hcl` | Mock-provider offline plan |
| `terraform.tfvars.example` | Sample vars |

## Resources (12)

- `aws_s3_bucket` + versioning + public access block
- `aws_iam_role` + basic execution policy
- `aws_lambda_function` (Python 3.11)
- `aws_apigatewayv2_api` + integration + routes + stage
- `aws_lambda_permission`
