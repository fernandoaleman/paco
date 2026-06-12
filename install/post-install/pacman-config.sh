#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

paco_section "Tuning pacman config"

# Enable color in pacman output.
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf

# Enable parallel downloads (5 concurrent).
sudo sed -i 's/^#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf

# Easter egg: Pac-Man-style progress bar.
if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
  sudo sed -i '/^# Misc options/a ILoveCandy' /etc/pacman.conf
fi

echo "pacman tuned: Color + ParallelDownloads=5 + ILoveCandy"
