#!/usr/bin/env bash
# Local CI simulation (lint + test) — no Docker required.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SERVICE="${ROOT}/../I4-convert-pair/service"
CLIENT="${ROOT}/../I4-convert-pair/client"

echo "==> D3 local CI — service lint + test"
cd "${SERVICE}"

if [ -d .venv ]; then
  # shellcheck disable=SC1091
  source .venv/bin/activate
fi

python3 -m pip install -q -r requirements-dev.txt
ruff check app tests
pytest -q --tb=short

echo "==> D3 local CI — client tests"
cd "${CLIENT}"
npm test

echo "OK — local CI green (docker build skipped — no Docker on this machine)"
