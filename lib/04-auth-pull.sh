#!/usr/bin/env bash
# =============================================================================
# 04-auth-pull.sh — Container image pulling for Trial Package (zero-credential)
# =============================================================================
echo ""
SERVER_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
SERVER_IP=${SERVER_IP:-127.0.0.1}
success "Server IP detected: ${SERVER_IP}"

echo ""
info "── Pulling GoSecureShare Images ─────────────────────────────"

if [[ -n "${GHCR_USERNAME:-}" && -n "${GHCR_TOKEN:-}" ]]; then
  info "Logging in to GHCR as ${GHCR_USERNAME}..."
  echo "${GHCR_TOKEN}" | docker login ghcr.io -u "${GHCR_USERNAME}" --password-stdin     && success "GHCR login successful."     || warn "GHCR login failed — attempting direct image pull..."
else
  info "Pulling trial package images (public distribution)..."
fi

echo ""
PULL_FAILED=()
for IMAGE in "${ALL_IMAGES[@]}"; do
  info "  Pulling ${IMAGE}..."
  if docker pull "${IMAGE}"; then
    success "  ${IMAGE}"
  else
    warn "  Failed to pull: ${IMAGE}"
    PULL_FAILED+=("${IMAGE}")
  fi
done
echo ""

if [[ ${#PULL_FAILED[@]} -gt 0 ]]; then
  echo -e "${RED}[ERROR]${RESET} Failed to pull container images:"
  printf '         - %s\n' "${PULL_FAILED[@]}"
  exit 1
fi
success "All images ready (tag: ${VERSION})."
echo ""
