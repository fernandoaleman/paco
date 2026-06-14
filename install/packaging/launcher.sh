#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing Vicinae launcher"

# Q13: Vicinae is paco's primary launcher (Raycast-compatible).
# Vicinae lives in the AUR; try common names. If none exist, fall back to
# clear instructions for the user.
CANDIDATES=(vicinae vicinae-bin vicinae-git)

if paco-pkg-present "${CANDIDATES[0]}" ||
  paco-pkg-present "${CANDIDATES[1]}" ||
  paco-pkg-present "${CANDIDATES[2]}"; then
  echo "Vicinae already installed. Skipping."
  exit 0
fi

# Try the candidates in order via yay.
for pkg in "${CANDIDATES[@]}"; do
  if yay -Si "${pkg}" > /dev/null 2>&1; then
    echo "Installing ${pkg} from AUR..."
    paco-pkg-aur-add "${pkg}"
    echo "Vicinae installed (package: ${pkg})."
    exit 0
  fi
done

echo "WARN: None of these vicinae package names exist in AUR: ${CANDIDATES[*]}"
echo "      Check https://aur.archlinux.org/packages?K=vicinae and install manually."
echo "      iter 16 will continue but Vicinae won't be available until installed."
