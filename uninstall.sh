#!/usr/bin/env bash
# uninstall.sh — Remove nvim-setup symlinks and optionally restore backups
# Usage: ./uninstall.sh

set -euo pipefail

NVIM_CONFIG_DST="${HOME}/.config/nvim"

log()  { printf '\033[1;34m[nvim-setup]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[nvim-setup]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[nvim-setup]\033[0m %s\n' "$*"; }

# ─── Remove symlink ──────────────────────────────────────────────────────────

if [[ -L "${NVIM_CONFIG_DST}" ]]; then
  log "Removing symlink: ${NVIM_CONFIG_DST}"
  rm "${NVIM_CONFIG_DST}"
  ok "Symlink removed"
elif [[ -e "${NVIM_CONFIG_DST}" ]]; then
  warn "${NVIM_CONFIG_DST} exists but is not a symlink — leaving it untouched"
else
  warn "${NVIM_CONFIG_DST} does not exist — nothing to remove"
fi

# ─── Restore most recent backup ───────────────────────────────────────────────

LATEST_BACKUP="$(ls -dt "${NVIM_CONFIG_DST}.bak."* 2>/dev/null | head -1 || true)"

if [[ -n "$LATEST_BACKUP" ]]; then
  read -rp "Restore backup ${LATEST_BACKUP}? [y/N] " answer
  if [[ "${answer,,}" == "y" ]]; then
    mv "$LATEST_BACKUP" "${NVIM_CONFIG_DST}"
    ok "Restored ${LATEST_BACKUP} → ${NVIM_CONFIG_DST}"
  else
    log "Skipping restore. Backup remains at: ${LATEST_BACKUP}"
  fi
else
  log "No backup found for ${NVIM_CONFIG_DST}"
fi

ok "Uninstall complete"
