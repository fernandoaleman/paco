#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing fonts (4 packages)"

# Q35 bundle: nerd monospace + universal sans/serif + emoji + Liberation aliases.
FONTS=(ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji ttf-liberation)

missing=()
for f in "${FONTS[@]}"; do
  paco-pkg-present "${f}" || missing+=("${f}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "All fonts already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "fonts installed: ${FONTS[*]}"
