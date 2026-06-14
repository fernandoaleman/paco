#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Overriding Chrome .desktop so Vicinae opens new windows"

# Per user feedback: launching Chrome from Vicinae with the stock
# .desktop file just raises the existing instance (Chrome's singleton
# behavior). Paco ships an override that puts --new-window in the main
# Exec line — symlinked at the user level, which fully shadows
# /usr/share/applications/google-chrome.desktop so Vicinae shows a
# single Chrome entry that always opens a fresh window. Incognito
# stays available via the Action sub-entry.
target_dir="${HOME}/.local/share/applications"
target="${target_dir}/google-chrome.desktop"
source_file="${PACO_PATH}/default/applications/google-chrome.desktop"

mkdir -p "${target_dir}"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "Chrome --new-window override already symlinked."
  exit 0
fi

if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_file}" "${target}"
echo "Symlinked ${target} → ${source_file}"

# Update the desktop database so launchers re-scan immediately. Best
# effort — if update-desktop-database is missing, it's not critical.
if command -v update-desktop-database > /dev/null 2>&1; then
  update-desktop-database "${target_dir}" > /dev/null 2>&1 || true
fi
