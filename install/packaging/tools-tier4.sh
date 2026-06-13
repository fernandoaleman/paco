#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing CLI tier-4 tools (3)"

# Q21 tier-4: delta (Arch pkg: git-delta, binary: delta), procs, hyperfine.
TOOLS=(git-delta procs hyperfine)

missing=()
for t in "${TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "All tier-4 tools already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "tier-4 tools installed: ${TOOLS[*]}"
