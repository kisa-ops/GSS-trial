#!/usr/bin/env bash
# =============================================================================
# sync-from-release.sh — Sync Latest Stable Licensed Release to Trial Package
# Usage: ./sync-from-release.sh [version_tag]
# Example: ./sync-from-release.sh 2.1.34
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_VERSION="${1:-}"

if [[ -z "${TARGET_VERSION}" ]]; then
  echo "[INFO] No version specified. Auto-detecting latest stable release from GoSecureShare-Platform..."
  PLATFORM_REPO_DIR="/home/anand/projects/GoSecureShare-Platform"
  if [[ -d "${PLATFORM_REPO_DIR}" ]]; then
    TARGET_VERSION=$(git -C "${PLATFORM_REPO_DIR}" tag --sort=-creatordate 2>/dev/null | head -1 | sed 's/^v//' || echo "")
  fi
fi

if [[ -z "${TARGET_VERSION}" ]]; then
  echo "[ERROR] Could not detect latest version. Usage: ./sync-from-release.sh <version>"
  exit 1
fi

echo "[INFO] Syncing GSS-trial to stable release version: ${TARGET_VERSION}"

# Update default pinned version in lib/03-version.sh
sed -i -E "s/echo "[0-9]+\.[0-9]+\.[0-9]+"/echo "${TARGET_VERSION}"/" "${SCRIPT_DIR}/lib/03-version.sh"

echo "[OK] Version updated to ${TARGET_VERSION} in lib/03-version.sh"
echo "[INFO] You can now commit and tag this release in GSS-trial:"
echo "       git add -A"
echo "       git commit -m \"chore: sync trial package to stable release v${TARGET_VERSION}\""
echo "       git tag v${TARGET_VERSION}"
echo "       git push origin main --tags"
