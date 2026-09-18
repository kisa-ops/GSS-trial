#!/usr/bin/env bash
# =============================================================================
# 00-globals.sh — Colors, logging helpers, registry constants, image names
# GoSecureShare 30-Day Evaluation / Trial Edition
# Sourced by install.sh — do not execute directly.
# =============================================================================

INSTALLER_VERSION="1.2.0-trial"

RED=$'[0;31m'; GREEN=$'[0;32m'; YELLOW=$'[1;33m'
CYAN=$'[0;36m'; BOLD=$'[1m'; DIM=$'[2m'; RESET=$'[0m'

info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; exit 1; }

REGISTRY="ghcr.io"
NAMESPACE="kisa-ops"
GITHUB_REPO="kisa-ops/GSS-trial"

IMAGE_API_PLATFORM="${REGISTRY}/${NAMESPACE}/gosecureshare-api-platform"
IMAGE_API_RECIPIENT="${REGISTRY}/${NAMESPACE}/gosecureshare-api-recipient"
IMAGE_FRONTEND_PLATFORM="${REGISTRY}/${NAMESPACE}/gosecureshare-frontend-platform"
IMAGE_FRONTEND_RECIPIENT="${REGISTRY}/${NAMESPACE}/gosecureshare-frontend-recipient"

INSTALL_DIR="/opt/gosecureshare"
