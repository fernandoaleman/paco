#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing dev tools (bats)"

if paco-pkg-present bats; then
  echo "bats already installed. Skipping."
  exit 0
fi

paco-pkg-add bats
echo "bats installed. Run tests with: bats ~/.local/share/paco/tests/"
