#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

paco_section "Tuning pacman config"

changed=false

# Enable color in pacman output (only if still commented).
if grep -q '^#Color' /etc/pacman.conf; then
  sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
  changed=true
fi

# Enable parallel downloads (only if not already at 5).
if ! grep -q '^ParallelDownloads = 5' /etc/pacman.conf; then
  sudo sed -i 's/^#\?ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf
  changed=true
fi

# Easter egg: Pac-Man-style progress bar (only if not already present).
if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
  sudo sed -i '/^# Misc options/a ILoveCandy' /etc/pacman.conf
  changed=true
fi

if [[ "${changed}" == "true" ]]; then
  echo "pacman tuned: Color + ParallelDownloads=5 + ILoveCandy"
else
  echo "pacman config already tuned. Skipping."
fi
