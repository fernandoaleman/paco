#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing CLI tier-1 tools (5)"

# Q21 tier-1: bat, bottom (binary btm), lazydocker, lazygit, tmux
TOOLS=(bat bottom lazydocker lazygit tmux)

missing=()
for t in "${TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "All tier-1 tools already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "tier-1 tools installed: ${TOOLS[*]}"
