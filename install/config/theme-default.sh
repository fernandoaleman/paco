#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Setting initial paco theme (catppuccin-macchiato)"

# If a theme is already set, leave it alone (user may have switched).
if [[ -d "${HOME}/.config/paco/current/theme" ]] &&
  [[ -f "${HOME}/.config/paco/current/theme-name" ]]; then
  current="$(cat "${HOME}/.config/paco/current/theme-name")"
  echo "Theme already set: ${current}. Skipping."
  exit 0
fi

paco-theme-set catppuccin-macchiato
