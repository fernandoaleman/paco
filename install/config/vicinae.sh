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

echo "Vicinae binary found: $(command -v vicinae)"

# Vicinae runs as a systemd user service (the daemon backs the launcher).
# The CLI `vicinae` talks to that service. Without the service running,
# Super+Space exec's the CLI but nothing visible happens.
if systemctl --user is-active vicinae.service > /dev/null 2>&1; then
  echo "vicinae.service already active."
elif systemctl --user enable --now vicinae.service 2> /dev/null; then
  echo "Enabled and started vicinae.service."
else
  echo "WARN: Could not enable vicinae.service — no user session bus yet?"
  echo "      Run this manually after your next login:"
  echo "        systemctl --user enable --now vicinae.service"
fi
