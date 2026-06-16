#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing file managers (Thunar GUI + yazi TUI per Q16)"

# Per Q16: Thunar over Nautilus for the lighter dep tree, yazi (Rust)
# for the TUI side with image preview via ghostty's Kitty graphics
# protocol.
#
# Thunar bundle (10 pkgs, all from extra):
#   thunar                  — core
#   thunar-volman           — auto-mount removable media
#   thunar-archive-plugin   — right-click compress/extract
#   file-roller             — archive manager backend for the plugin
#   tumbler                 — thumbnail daemon (Thunar's backend)
#   ffmpegthumbnailer       — video thumbnails
#   gvfs                    — virtual filesystem (trash/FTP/archive)
#   gvfs-mtp                — Android MTP support
#   gvfs-smb                — SMB/CIFS shares
#   gvfs-nfs                — NFS shares
#
# yazi bundle (4 pkgs, all from extra):
#   yazi                    — Rust TUI file manager
#   7zip                    — modern archive lib for previewers
#   poppler                 — PDF preview rendering
#   imagemagick             — image format conversion for previewers
#
# (ueberzugpp NOT needed — ghostty implements the Kitty graphics
# protocol natively, which yazi auto-detects.)
PACMAN_TOOLS=(
  thunar
  thunar-volman
  thunar-archive-plugin
  file-roller
  tumbler
  ffmpegthumbnailer
  gvfs
  gvfs-mtp
  gvfs-smb
  gvfs-nfs
  yazi
  7zip
  poppler
  imagemagick
)

missing=()
for t in "${PACMAN_TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "File managers already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"

echo "File managers present: ${PACMAN_TOOLS[*]}"
