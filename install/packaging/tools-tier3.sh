#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing CLI tier-3 tools (3)"

# Q21 tier-3: mise (Rust ver-mgr), sesh (Go tmux session mgr), gh (GitHub CLI).
# Arch package for gh is github-cli (binary is `gh`).
TOOLS=(mise sesh github-cli)

missing=()
for t in "${TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "All tier-3 tools already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "tier-3 tools installed: ${TOOLS[*]}"
