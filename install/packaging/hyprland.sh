#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing Hyprland + Wayland session deps"

# hyprland:                       the compositor
# xdg-desktop-portal-hyprland:    screen sharing, file pickers
# polkit-gnome:                   privilege auth dialogs in GUI
# qt5-wayland, qt6-wayland:       Qt apps on Wayland
# wl-clipboard:                   wl-copy / wl-paste (also resolves nvim's
#                                 clipboard warning post-Wayland)
# hyprland-guiutils:              auxiliary tools, includes start-hyprland
# uwsm:                           session/service manager — used in iter 15
#                                 for SDDM launch wrapper
TOOLS=(
  hyprland
  xdg-desktop-portal-hyprland
  polkit-gnome
  qt5-wayland
  qt6-wayland
  wl-clipboard
  hyprland-guiutils
  uwsm
)

missing=()
for t in "${TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "Hyprland session deps already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "Hyprland session deps installed."
