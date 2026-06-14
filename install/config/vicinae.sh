#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring Vicinae launcher"

if ! command -v vicinae > /dev/null 2>&1; then
  echo "WARN: vicinae binary not found in PATH."
  echo "      Was the AUR install successful in install/packaging/launcher.sh?"
  echo "      Skipping config; Super+Space binding won't work until vicinae is installed."
  exit 0
fi

# Vicinae's expected config location and startup mechanism may vary by
# packaging version. For now, just verify the binary works; user config
# at ~/.config/vicinae/ (if any) gets created on first launch.
echo "Vicinae binary found: $(command -v vicinae)"
echo "(Super+Space launches it via Hyprland's bindings/launcher.lua.)"
