#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${KIND_CLUSTER_NAME:-convert-d4}"

if command -v kind >/dev/null 2>&1; then
  kind delete cluster --name "${CLUSTER_NAME}" || true
else
  kubectl delete -f "$(cd "$(dirname "$0")/.." && pwd)/k8s/" --ignore-not-found
fi

echo "Stack torn down"
