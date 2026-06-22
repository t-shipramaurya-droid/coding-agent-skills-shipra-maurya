#!/usr/bin/env bash
# One-command verification for assignment artifacts (no Docker required).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ARTIFACTS="${ROOT}/artifacts"
PASS=0
FAIL=0
SKIP=0

activate_venv() {
  local dir="$1"
  if [ -f "${dir}/.venv/bin/activate" ]; then
    # shellcheck disable=SC1091
    source "${dir}/.venv/bin/activate"
  fi
}

run_step() {
  local name="$1"
  shift
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "▶ ${name}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if "$@"; then
    echo "✅ ${name}"
    PASS=$((PASS + 1))
  else
    echo "❌ ${name}"
    FAIL=$((FAIL + 1))
    return 1
  fi
}

skip_step() {
  local name="$1"
  local reason="$2"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "▶ ${name} — SKIPPED (${reason})"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  SKIP=$((SKIP + 1))
}

verify_b4() {
  cd "${ARTIFACTS}/B4-fastapi"
  activate_venv "$(pwd)"
  if ! python3 -m pytest --version >/dev/null 2>&1; then
    python3 -m pip install -q -r requirements.txt pytest httpx
  fi
  python3 -m pytest -q
}

verify_b5() {
  cd "${ARTIFACTS}/B5-nodejs"
  npm test --silent
}

verify_b6() {
  cd "${ARTIFACTS}/B6-rust-logcounter"
  cargo test -q
}

verify_i4() {
  cd "${ARTIFACTS}/I4-convert-pair/service"
  activate_venv "$(pwd)"
  python3 -m pip install -q -r requirements-dev.txt
  python3 -m pytest -q --tb=line
  cd "${ARTIFACTS}/I4-convert-pair/client"
  npm test --silent
}

verify_d1() {
  cd "${ARTIFACTS}/D1-terraform"
  if command -v terraform >/dev/null 2>&1; then
    terraform test
  else
    echo "terraform not installed — validating files only"
    test -f main.tf && test -f tests/main.tftest.hcl
  fi
}

verify_d2_local() {
  bash "${ARTIFACTS}/D2-compose-stack/scripts/test-stack-local.sh"
}

verify_d3_local() {
  bash "${ARTIFACTS}/D3-ci/scripts/run-ci-local.sh"
  test -s "${ARTIFACTS}/D3-ci/artifacts/failure-demo.log"
}

verify_d4() {
  bash "${ARTIFACTS}/D4-kubernetes/scripts/validate.sh"
}

verify_d6_local() {
  bash "${ARTIFACTS}/D6-observability/scripts/prove-local.sh"
}
verify_a3() {
  cd "${ARTIFACTS}/A3-fraud-score/engine" && cargo test -q
  cd "${ARTIFACTS}/A3-fraud-score/service"
  activate_venv "$(pwd)"
  if ! python3 -m pytest --version >/dev/null 2>&1; then
    python3 -m pip install -q pytest httpx
  fi
  python3 -m pytest -q
}

echo "PM4-6558 assignment verification (offline-friendly)"
echo "Root: ${ROOT}"

set +e
run_step "B4 FastAPI tests" verify_b4
run_step "B5 Node.js tests" verify_b5
run_step "B6 Rust tests" verify_b6
run_step "I4 convert pair (pytest + npm)" verify_i4
run_step "A3 fraud-score unit tests" verify_a3
run_step "D1 Terraform" verify_d1
run_step "D2 local E2E (memory store)" verify_d2_local
run_step "D3 local CI + failure log" verify_d3_local
run_step "D4 Kubernetes validate" verify_d4
run_step "D6 observability local proof" verify_d6_local
set -e

if command -v docker >/dev/null 2>&1; then
  run_step "D2 Docker stack" bash "${ARTIFACTS}/D2-compose-stack/scripts/test-stack.sh" || true
else
  skip_step "D2 Docker stack" "no docker"
  skip_step "I5 docker build" "no docker — see D3 CI docker-build job"
  skip_step "D6 Grafana compose" "no docker"
fi

echo ""
echo "════════════════════════════════════════"
echo "Summary: ${PASS} passed, ${FAIL} failed, ${SKIP} skipped"
echo "════════════════════════════════════════"

if [ "${FAIL}" -gt 0 ]; then
  exit 1
fi
