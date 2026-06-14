#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing Waybar + Mako"

TOOLS=(waybar mako)

missing=()
for t in "${TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "Waybar + Mako already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "Waybar + Mako installed."
