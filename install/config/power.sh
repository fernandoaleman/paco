#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring power management (power-profiles-daemon)"

# Enable + start power-profiles-daemon. Provides the 3-mode picker
# (power-saver / balanced / performance) via `powerprofilesctl` + the
# waybar power module (deferred). Safe on desktops too — without a
# battery the daemon still exposes the profiles, they just have no
# performance effect.
#
# Per Q26: omarchy auto-switches profile on AC plug/unplug via udev
# rules gated on battery presence. paco defers that to a future iter
# — for v0.1.0 the manual picker is enough.
if systemctl is-enabled power-profiles-daemon.service > /dev/null 2>&1; then
  echo "power-profiles-daemon.service already enabled."
else
  sudo systemctl enable power-profiles-daemon.service
  echo "Enabled power-profiles-daemon.service."
fi

if systemctl is-active power-profiles-daemon.service > /dev/null 2>&1; then
  echo "power-profiles-daemon.service already active."
else
  sudo systemctl start power-profiles-daemon.service
  echo "Started power-profiles-daemon.service."
fi
