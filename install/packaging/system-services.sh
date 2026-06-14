#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing system services (network, bluetooth, audio, power, firewall)"

# Pacman packages for iter 19 system services:
#   Networking (Q27):
#     networkmanager         — daemon (deviation from omarchy's iwd)
#     network-manager-applet — provides nm-applet for waybar tray
#     nm-connection-editor   — GUI launched by waybar network module
#   Bluetooth (Q28):
#     bluez, bluez-utils, blueman
#   Audio (Q25 — archinstall installs a base set; ensure the full ecosystem):
#     pipewire, pipewire-alsa, pipewire-pulse, pipewire-jack
#     wireplumber                                  — session manager
#     pavucontrol                                  — GUI mixer
#     playerctl                                    — media key control
#   Power (Q26):
#     power-profiles-daemon
#   Firewall (Q27 + Q44):
#     ufw
PACMAN_TOOLS=(
  networkmanager
  network-manager-applet
  nm-connection-editor
  bluez
  bluez-utils
  blueman
  pipewire
  pipewire-alsa
  pipewire-pulse
  pipewire-jack
  wireplumber
  pavucontrol
  playerctl
  power-profiles-daemon
  ufw
)

missing=()
for t in "${PACMAN_TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "System services already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"

echo "System services present: ${PACMAN_TOOLS[*]}"
