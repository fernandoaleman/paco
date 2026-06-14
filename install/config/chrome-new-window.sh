#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing Chrome launcher overrides (Vicinae always opens new window)"

# Two .desktop files ship for Chrome (see headers of each for the why):
#   - google-chrome.desktop  → hidden (NoDisplay=true); preserves
#                              xdg-open / xdg-settings URL routing
#                              with --new-window in Exec.
#   - paco-chrome.desktop    → user-visible; filename intentionally
#                              differs from Chrome's WM class so
#                              Vicinae's matchesWindowClass() fails
#                              and Enter always launches a fresh
#                              Chrome window (consistency with the
#                              webapp .desktop entries).
target_dir="${HOME}/.local/share/applications"
mkdir -p "${target_dir}"

# Helper: symlink ${source} → ${target}, backing up existing non-link
# files. Idempotent.
link_desktop() {
  local name="$1"
  local source_file="${PACO_PATH}/default/applications/${name}"
  local target="${target_dir}/${name}"

  if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
    echo "${name} already symlinked."
    return 0
  fi

  if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
    local backup
    backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing ${target} → ${backup}"
    mv "${target}" "${backup}"
  fi

  ln -sfn "${source_file}" "${target}"
  echo "Symlinked ${target} → ${source_file}"
}

link_desktop "google-chrome.desktop"
link_desktop "paco-chrome.desktop"

# Refresh the desktop database so Vicinae re-scans immediately. Best
# effort — if update-desktop-database is missing, not critical.
if command -v update-desktop-database > /dev/null 2>&1; then
  update-desktop-database "${target_dir}" > /dev/null 2>&1 || true
fi
