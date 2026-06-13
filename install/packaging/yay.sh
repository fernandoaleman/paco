#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing yay (AUR helper)"

# Idempotency: skip if already installed.
if paco-pkg-present yay; then
  echo "yay already installed. Skipping."
  exit 0
fi

# Prereqs: base-devel + git for AUR builds.
paco-pkg-add base-devel git

# Clone, build, install yay from AUR.
build_dir="$(mktemp -d)"
trap 'rm -rf "${build_dir}"' EXIT

echo "Cloning yay from AUR..."
git clone https://aur.archlinux.org/yay.git "${build_dir}/yay"

echo "Building and installing yay..."
cd "${build_dir}/yay"
makepkg -si --noconfirm

echo "yay installed: $(yay --version | head -n 1)"
