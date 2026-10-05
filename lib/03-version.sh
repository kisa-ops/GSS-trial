#!/usr/bin/env bash
# =============================================================================
# 03-version.sh — Resolve image version for Trial Package
# =============================================================================
info "Resolving image version..."

_resolve_version() {
  if [[ -n "${GSS_VERSION:-}" ]]; then
    echo "${GSS_VERSION#v}"
    return
  fi
  local api_url="https://api.github.com/repos/${GITHUB_REPO}/releases/latest"
  local tag
  tag=$(curl -fsSL --connect-timeout 6 -H "Accept: application/vnd.github+json" "${api_url}" 2>/dev/null \
    | grep '"tag_name"' | sed 's/.*"tag_name": "\(.*\)".*/\1/' | tr -d '[:space:]' | sed 's/^v//' || echo "")
  if [[ -n "${tag}" && "${tag}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "${tag}"
  else
    echo "2.1.45"
  fi
}

VERSION="$(_resolve_version)"
success "Installing version: ${VERSION} (Evaluation Edition)"
GIT_REF="v${VERSION}"

TAGGED_API_PLATFORM="${IMAGE_API_PLATFORM}:${VERSION}"
TAGGED_API_RECIPIENT="${IMAGE_API_RECIPIENT}:${VERSION}"
TAGGED_FRONTEND_PLATFORM="${IMAGE_FRONTEND_PLATFORM}:${VERSION}"
TAGGED_FRONTEND_RECIPIENT="${IMAGE_FRONTEND_RECIPIENT}:${VERSION}"
ALL_IMAGES=(
  "${TAGGED_API_PLATFORM}"
  "${TAGGED_API_RECIPIENT}"
  "${TAGGED_FRONTEND_PLATFORM}"
  "${TAGGED_FRONTEND_RECIPIENT}"
  "postgres:16-alpine"
  "nginx:1.27-alpine"
)
