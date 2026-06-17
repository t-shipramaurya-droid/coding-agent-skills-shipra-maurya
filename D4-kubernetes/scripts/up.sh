#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SERVICE_DIR="${ROOT}/../I4-convert-pair/service"
K8S_DIR="${ROOT}/k8s"
CLUSTER_NAME="${KIND_CLUSTER_NAME:-convert-d4}"
IMAGE="i4-convert-service:latest"

command -v kind >/dev/null || { echo "kind not found — install kind + Docker"; exit 1; }
command -v docker >/dev/null || { echo "docker not found"; exit 1; }

echo "==> Create kind cluster"
kind create cluster --name "${CLUSTER_NAME}" --config "${ROOT}/kind-config.yaml" --wait 120s

echo "==> Build and load image"
docker build -t "${IMAGE}" "${SERVICE_DIR}"
kind load docker-image "${IMAGE}" --name "${CLUSTER_NAME}"

echo "==> Apply manifests"
kubectl apply -f "${K8S_DIR}/"

echo "==> Wait for deployment"
kubectl -n convert-service rollout status deployment/convert-service --timeout=120s

echo "==> Smoke test via port-forward"
kubectl -n convert-service port-forward svc/convert-service 18000:80 &
PF_PID=$!
sleep 3

curl -sf http://127.0.0.1:18000/health
curl -sf -X POST http://127.0.0.1:18000/convert \
  -H 'Content-Type: application/json' \
  -d '{"amount":100,"from_currency":"USD","to_currency":"INR"}'

kill "${PF_PID}" 2>/dev/null || true
echo "OK — cluster up and smoke test passed"
