#!/usr/bin/env bash
# =============================================================================
# GoSecureShare — 30-Day Evaluation / Trial Automated Installer
# Supports: Ubuntu 20.04+, Debian 11+, Rocky/RHEL 8+
# Usage:    chmod +x install.sh && sudo ./install.sh
# One-liner: curl -fsSL https://raw.githubusercontent.com/kisa-ops/GSS-trial/main/install.sh | sudo bash
#
# ZERO-DEPENDENCY TRIAL DISTRIBUTION:
#   • No GitHub Personal Access Token (PAT) or repository sharing needed.
#   • Completely standalone package separated from enterprise distribution.
#   • Automatically activates 30-day full enterprise trial upon installation.
#   • 100% offline verification — zero phone-home calls or public license server.
#
# PORT DEFAULTS:
#   Platform  (internal admin UI):  HTTP 8181  →  HTTPS 443 (behind host Nginx)
#   Recipient (external share UI):  HTTP 80    →  HTTPS 443 (behind host Nginx)
#
# VERSION PINNING:
#   Defaults to latest stable pinned release tag. Override:
#     GSS_VERSION=2.1.33 sudo ./install.sh
# =============================================================================
set -euo pipefail

_SCRIPT_DIR_EARLY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_GLOBALS_EARLY="${_SCRIPT_DIR_EARLY}/lib/00-globals.sh"
if [[ -f "${_GLOBALS_EARLY}" ]]; then
  INSTALLER_VERSION=$(grep -E '^INSTALLER_VERSION=' "${_GLOBALS_EARLY}"     | head -1 | cut -d'"' -f2 || echo "1.2.0")
else
  INSTALLER_VERSION="1.2.0-trial"
fi

RED=$'[0;31m'; GREEN=$'[0;32m'; YELLOW=$'[1;33m'
CYAN=$'[0;36m'; BOLD=$'[1m'; RESET=$'[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"

if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}[ERROR]${RESET} Please run as root: sudo ./install.sh" >&2
  exit 1
fi

echo ""
echo -e "${BOLD}${GREEN}╔$(printf '═%.0s' {1..64})╗${RESET}"
echo -e "${BOLD}${GREEN}║      GoSecureShare — 30-Day Evaluation / Trial Package         ║${RESET}"
echo -e "${BOLD}${GREEN}║      Self-Hosted Zero-Knowledge Secret Sharing Platform        ║${RESET}"
echo -e "${BOLD}${GREEN}║      Installer version: ${INSTALLER_VERSION}$(printf ' %.0s' $(seq 1 $((37 - ${#INSTALLER_VERSION}))))║${RESET}"
echo -e "${BOLD}${GREEN}╚$(printf '═%.0s' {1..64})╝${RESET}"
echo ""
echo -e "  ${CYAN}[INFO]${RESET}  Free 30-day evaluation with all enterprise features unlocked."
echo -e "  ${CYAN}[INFO]${RESET}  No GitHub Personal Access Token (PAT) or repo invite required."
echo -e "  ${CYAN}[INFO]${RESET}  License automatically activates locally upon installation."
echo ""

GHCR_USERNAME="${GHCR_USERNAME:-}"
GHCR_TOKEN="${GHCR_TOKEN:-}"
GHCR_IMAGES_PRIVATE="${GHCR_IMAGES_PRIVATE:-false}"
export GHCR_USERNAME GHCR_TOKEN GHCR_IMAGES_PRIVATE

if [[ -n "${GSS_VERSION:-}" ]]; then
  echo -e "  ${CYAN}[INFO]${RESET}  Version override detected: ${BOLD}${GSS_VERSION}${RESET}"
else
  echo -e "  ${CYAN}[INFO]${RESET}  Version: auto-detect from latest stable release"
fi
echo ""

LIB_FILES=(
  "00-globals.sh"
  "01-reinstall.sh"
  "02-prerequisites.sh"
  "03-version.sh"
  "04-auth-pull.sh"
  "05-db-files.sh"
  "06-config.sh"
  "07-ssl.sh"
  "08-secrets.sh"
  "09-write-files.sh"
  "10-start.sh"
)

LIB_REF="${GSS_LIB_REF:-main}"
LIB_BASE_URL="https://raw.githubusercontent.com/kisa-ops/GSS-trial/${LIB_REF}/lib"

_needs_bootstrap=false
for _f in "${LIB_FILES[@]}"; do
  [[ ! -f "${LIB_DIR}/${_f}" ]] && { _needs_bootstrap=true; break; }
done

if [[ "${_needs_bootstrap}" == "true" ]]; then
  echo -e "${CYAN}[INFO]${RESET}  lib/ not found — fetching from GSS-trial repository..."
  echo ""
  mkdir -p "${LIB_DIR}"
  _curl_auth=()
  [[ -n "${GHCR_TOKEN:-}" ]] && _curl_auth=(-H "Authorization: Bearer ${GHCR_TOKEN}")
  _bootstrap_failed=false
  for _f in "${LIB_FILES[@]}"; do
    if curl -fsSL --connect-timeout 10         "${_curl_auth[@]}"         "${LIB_BASE_URL}/${_f}"         -o "${LIB_DIR}/${_f}" 2>/dev/null; then
      echo -e "${GREEN}[OK]${RESET}    Fetched: lib/${_f}"
    else
      echo -e "${RED}[ERROR]${RESET} Failed to fetch: lib/${_f}" >&2
      _bootstrap_failed=true
    fi
  done
  echo ""
  if [[ "${_bootstrap_failed}" == "true" ]]; then
    echo -e "${RED}[ERROR]${RESET} Could not fetch trial components from GitHub." >&2
    echo -e "        Please ensure internet connectivity or clone https://github.com/kisa-ops/GSS-trial" >&2
    rm -rf "${LIB_DIR}"
    exit 1
  fi
  chmod +x "${LIB_DIR}"/*.sh
  echo -e "${GREEN}[OK]${RESET}    All lib files ready."
  echo ""
fi

if [[ -f "${LIB_DIR}/00-globals.sh" ]]; then
  INSTALLER_VERSION=$(grep -E '^INSTALLER_VERSION=' "${LIB_DIR}/00-globals.sh"     | head -1 | cut -d'"' -f2 || echo "1.2.0")
fi

for _f in "${LIB_FILES[@]}"; do
  if [[ ! -f "${LIB_DIR}/${_f}" ]]; then
    echo -e "${RED}[ERROR]${RESET} Missing lib file: lib/${_f}" >&2
    exit 1
  fi
done

. "${LIB_DIR}/00-globals.sh"
. "${LIB_DIR}/01-reinstall.sh"
. "${LIB_DIR}/02-prerequisites.sh"
. "${LIB_DIR}/03-version.sh"
. "${LIB_DIR}/04-auth-pull.sh"
. "${LIB_DIR}/05-db-files.sh"
. "${LIB_DIR}/06-config.sh"
. "${LIB_DIR}/07-ssl.sh"
. "${LIB_DIR}/08-secrets.sh"
. "${LIB_DIR}/09-write-files.sh"
. "${LIB_DIR}/10-start.sh"
