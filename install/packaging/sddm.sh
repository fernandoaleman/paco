#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing SDDM display manager"

if paco-pkg-present sddm; then
  echo "sddm already installed. Skipping."
  exit 0
fi

paco-pkg-add sddm
echo "sddm installed."
