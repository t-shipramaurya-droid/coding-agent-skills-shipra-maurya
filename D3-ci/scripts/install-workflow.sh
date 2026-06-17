#!/usr/bin/env bash
# Copy workflow to repo root .github/workflows/ for GitHub Actions to pick it up.
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${1:-$(cd "${SRC}/../../.." && pwd)}"

mkdir -p "${DEST}/.github/workflows"
cp "${SRC}/.github/workflows/convert-service-ci.yml" "${DEST}/.github/workflows/convert-service-ci.yml"
echo "Installed workflow to ${DEST}/.github/workflows/convert-service-ci.yml"
