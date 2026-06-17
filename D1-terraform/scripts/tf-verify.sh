#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
TF="${TERRAFORM_BIN:-terraform}"

echo "==> terraform init"
$TF init -input=false

echo "==> terraform validate"
$TF validate

echo "==> terraform test (mock AWS plan)"
$TF test

echo "==> terraform plan"
$TF plan -input=false -out=tfplan

echo "OK — D1 verification complete"
