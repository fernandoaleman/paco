#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing zsh + plugins"

if paco-pkg-present zsh &&
  paco-pkg-present zsh-autosuggestions &&
  paco-pkg-present zsh-completions &&
  paco-pkg-present zsh-syntax-highlighting; then
  echo "zsh + plugins already installed. Skipping."
  exit 0
fi

paco-pkg-add zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
echo "zsh + 3 plugins installed."
