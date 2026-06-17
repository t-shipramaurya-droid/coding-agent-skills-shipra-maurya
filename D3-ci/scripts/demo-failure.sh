#!/usr/bin/env bash
# Demonstrates CI failure mode: inject a failing test, run pytest, capture output.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SERVICE="${ROOT}/../I4-convert-pair/service"
FAIL_TEST="${SERVICE}/tests/test_intentional_fail.py"
LOG="${ROOT}/artifacts/failure-demo.log"

mkdir -p "${ROOT}/artifacts"
cd "${SERVICE}"

if [ -d .venv ]; then
  # shellcheck disable=SC1091
  source .venv/bin/activate
fi

python3 -m pip install -q -r requirements-dev.txt

cat > "${FAIL_TEST}" <<'EOF'
def test_intentional_ci_failure_demo():
    """Removed after demo — simulates a broken commit failing CI."""
    assert 1 == 2, "D3 failure demo: deliberate test failure"
EOF

echo "==> Running pytest with intentional failure (expect non-zero exit)"
set +e
pytest -q --tb=short 2>&1 | tee "${LOG}"
EXIT_CODE=${PIPESTATUS[0]}
set -e

rm -f "${FAIL_TEST}"

if [ "${EXIT_CODE}" -eq 0 ]; then
  echo "ERROR: expected pytest to fail"
  exit 1
fi

echo "==> Failure demo complete — exit code ${EXIT_CODE}"
echo "Log saved to ${LOG}"
exit 0
