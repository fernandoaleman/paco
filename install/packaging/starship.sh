#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing starship prompt"

if paco-pkg-present starship; then
  echo "starship already installed. Skipping."
  exit 0
fi

paco-pkg-add starship
echo "starship installed."
