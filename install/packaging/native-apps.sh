#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing bundled native apps (Q20)"

# Per Q20: ship 5 native apps as defaults (chrome already lands in
# iter 20a). Per-item user approval has happened — see iter 20c
# preview discussion.
#
# AUR (5):
#   1password         — desktop GUI (stable; not the omarchy-beta)
#   1password-cli     — `op` command for shells / browser autofill
#   slack-desktop     — official Slack Linux binary
#   spotify           — official Spotify client
#   zennotes-bin      — keyboard-first Markdown notes; ships
#                       alongside Obsidian so users can compare
#                       (both read the same plain-.md vaults, so
#                       coexistence is trivial)
# extra (1):
#   obsidian          — mature notes app; the safe default
PACMAN_TOOLS=(obsidian)
AUR_TOOLS=(1password 1password-cli slack-desktop spotify zennotes-bin)

pacman_missing=()
for t in "${PACMAN_TOOLS[@]}"; do
  paco-pkg-present "${t}" || pacman_missing+=("${t}")
done

aur_missing=()
for t in "${AUR_TOOLS[@]}"; do
  paco-pkg-present "${t}" || aur_missing+=("${t}")
done

if [[ ${#pacman_missing[@]} -eq 0 ]] && [[ ${#aur_missing[@]} -eq 0 ]]; then
  echo "Native apps already installed. Skipping."
  exit 0
fi

if [[ ${#pacman_missing[@]} -gt 0 ]]; then
  paco-pkg-add "${pacman_missing[@]}"
fi

if [[ ${#aur_missing[@]} -gt 0 ]]; then
  paco-pkg-aur-add "${aur_missing[@]}"
fi

echo "Native apps present: ${PACMAN_TOOLS[*]} ${AUR_TOOLS[*]}"
