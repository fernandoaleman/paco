#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing boot stack (Plymouth + Limine + snapper)"

# Pacman:
#   plymouth:      graphical boot splash
#   snapper:       btrfs snapshot manager (root-only per Q43)
#   inotify-tools: provides inotifywait, which limine-snapper-sync.service
#                  uses for continuous watching of snapshot dir
PACMAN_TOOLS=(plymouth snapper inotify-tools)

# AUR:
#   limine-snapper-sync:    auto-create snapshots + populate Limine boot menu
#   limine-mkinitcpio-hook: rebuild UKI + update Limine entries on kernel changes
AUR_TOOLS=(limine-snapper-sync limine-mkinitcpio-hook)

pacman_missing=()
for t in "${PACMAN_TOOLS[@]}"; do
  paco-pkg-present "${t}" || pacman_missing+=("${t}")
done

aur_missing=()
for t in "${AUR_TOOLS[@]}"; do
  paco-pkg-present "${t}" || aur_missing+=("${t}")
done

if [[ ${#pacman_missing[@]} -eq 0 ]] && [[ ${#aur_missing[@]} -eq 0 ]]; then
  echo "Boot stack already installed. Skipping."
  exit 0
fi

if [[ ${#pacman_missing[@]} -gt 0 ]]; then
  paco-pkg-add "${pacman_missing[@]}"
fi

if [[ ${#aur_missing[@]} -gt 0 ]]; then
  paco-pkg-aur-add "${aur_missing[@]}"
fi

echo "Boot stack present: ${PACMAN_TOOLS[*]} ${AUR_TOOLS[*]}"
