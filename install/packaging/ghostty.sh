#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing ghostty terminal"

if paco-pkg-present ghostty; then
  echo "ghostty already installed. Skipping."
  exit 0
fi

paco-pkg-add ghostty
echo "ghostty installed."
