#!/usr/bin/env bash
# =============================================================================
# 05-db-files.sh — Resolve and copy DB bootstrap files for Trial
# Sourced by install.sh — do not execute directly.
# =============================================================================

echo ""
info "Creating installation directory: ${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}/db" "${INSTALL_DIR}/nginx"
success "Directory structure ready."

echo ""
info "── DB Files ────────────────────────────────────────────────"

if [[ -n "${GSS_DB_DIR:-}" ]]; then
  LOCAL_DB_DIR="${GSS_DB_DIR}"
  info "Using GSS_DB_DIR override: ${LOCAL_DB_DIR}"
elif [[ -f "${SCRIPT_DIR}/db/init.sql" && -f "${SCRIPT_DIR}/db/docker-migrate.sh" ]]; then
  LOCAL_DB_DIR="${SCRIPT_DIR}/db"
  info "Found local db/ folder next to install.sh: ${LOCAL_DB_DIR}"
else
  LOCAL_DB_DIR=""
fi

DB_REF="${GSS_DB_REF:-${GSS_LIB_REF:-main}}"
DB_RAW_BASE="https://raw.githubusercontent.com/kisa-ops/GSS-trial/${DB_REF}/db"

_resolve_db_file() {
  local file="$1"
  local dest="${INSTALL_DIR}/db/${file}"

  if [[ -n "${LOCAL_DB_DIR}" && -f "${LOCAL_DB_DIR}/${file}" ]]; then
    cp "${LOCAL_DB_DIR}/${file}" "${dest}"
    success "  Copied from local: ${file}"
    return 0
  fi

  if curl -fsSL --connect-timeout 10 "${DB_RAW_BASE}/${file}" -o "${dest}" 2>/dev/null; then
    success "  Fetched (raw): ${file}"
    return 0
  fi

  warn "  Could not fetch: ${file}"
  return 1
}

if [[ -z "${LOCAL_DB_DIR}" ]]; then
  info "No local db/ folder found — fetching from GSS-trial repository..."
fi

DB_FAILED=()
for _dbf in init.sql docker-migrate.sh; do
  _resolve_db_file "${_dbf}" || DB_FAILED+=("${_dbf}")
done

if [[ ${#DB_FAILED[@]} -gt 0 ]]; then
  echo ""
  echo -e "${RED}[ERROR]${RESET} Failed to fetch DB file(s): ${DB_FAILED[*]}" >&2
  exit 1
fi

chmod +x "${INSTALL_DIR}/db/docker-migrate.sh"
success "Database files ready."
