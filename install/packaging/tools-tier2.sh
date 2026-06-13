#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing CLI tier-2 tools (10)"

# Q21 tier-2 — tealdeer (Rust) substitutes for tldr; binary is `tldr`.
TOOLS=(dust eza fd fzf gum jq ripgrep tealdeer zoxide fastfetch)

missing=()
for t in "${TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "All tier-2 tools already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "tier-2 tools installed: ${TOOLS[*]}"
