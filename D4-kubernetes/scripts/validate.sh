#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
K8S_DIR="${ROOT}/k8s"
KUBECONFORM="${KUBECONFORM_BIN:-kubeconform}"

ensure_kubeconform() {
  if command -v "${KUBECONFORM}" >/dev/null 2>&1; then
    return 0
  fi
  if [ -x /tmp/kubeconform ]; then
    KUBECONFORM=/tmp/kubeconform
    return 0
  fi
  echo "Downloading kubeconform..."
  ARCH="$(uname -m)"
  case "${ARCH}" in
    arm64) KCF_ARCH=arm64 ;;
    x86_64) KCF_ARCH=amd64 ;;
    *) echo "Unsupported arch: ${ARCH}"; return 1 ;;
  esac
  curl -fsSL "https://github.com/yannh/kubeconform/releases/download/v0.6.7/kubeconform-darwin-${KCF_ARCH}.tar.gz" \
    | tar -xz -C /tmp
  KUBECONFORM=/tmp/kubeconform
}

echo "==> kubeconform schema validation (offline)"
ensure_kubeconform
"${KUBECONFORM}" -summary "${K8S_DIR}"/*.yaml

echo "==> kubectl server dry-run (requires cluster — skipped if unavailable)"
KUBECTL="${KUBECTL_BIN:-kubectl}"
if ! command -v "${KUBECTL}" >/dev/null 2>&1; then
  KUBECTL=/tmp/kubectl
fi
if [ -f "${HOME}/.kube/config" ] && "${KUBECTL}" cluster-info >/dev/null 2>&1; then
  "${KUBECTL}" apply --dry-run=server -f "${K8S_DIR}/"
else
  echo "SKIP: no cluster — kubeconform validation is sufficient offline"
fi

echo "OK — manifest validation complete"
