#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing Google Chrome (default web browser per Q17)"

# Chrome is a HARD dependency of the paco-webapp-* family — it powers
# the `--app=` mode that turns URLs into native-feeling desktop apps.
# AUR-only because Google distributes the binary directly.
if paco-pkg-present google-chrome; then
  echo "google-chrome already installed."
  exit 0
fi

paco-pkg-aur-add google-chrome
echo "Installed google-chrome."
