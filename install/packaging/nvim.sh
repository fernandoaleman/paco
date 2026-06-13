#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing neovim"

if paco-pkg-present neovim; then
  echo "neovim already installed. Skipping."
  exit 0
fi

paco-pkg-add neovim
echo "neovim installed."
