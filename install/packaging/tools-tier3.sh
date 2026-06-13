#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing CLI tier-3 tools (3)"

# Q21 tier-3: mise (Rust ver-mgr), sesh (Go tmux session mgr), gh (GitHub CLI).
# Arch package for gh is github-cli (binary is `gh`).
# sesh is in AUR, not extra.
PACMAN_TOOLS=(mise github-cli)
AUR_TOOLS=(sesh)

pacman_missing=()
for t in "${PACMAN_TOOLS[@]}"; do
  paco-pkg-present "${t}" || pacman_missing+=("${t}")
done

aur_missing=()
for t in "${AUR_TOOLS[@]}"; do
  paco-pkg-present "${t}" || aur_missing+=("${t}")
done

if [[ ${#pacman_missing[@]} -eq 0 ]] && [[ ${#aur_missing[@]} -eq 0 ]]; then
  echo "All tier-3 tools already installed. Skipping."
  exit 0
fi

if [[ ${#pacman_missing[@]} -gt 0 ]]; then
  paco-pkg-add "${pacman_missing[@]}"
fi

if [[ ${#aur_missing[@]} -gt 0 ]]; then
  paco-pkg-aur-add "${aur_missing[@]}"
fi

echo "tier-3 tools present: ${PACMAN_TOOLS[*]} ${AUR_TOOLS[*]}"
