#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Setting Plymouth theme (bgrt — UEFI firmware logo + spinner)"

# bgrt = built-in Plymouth theme that displays the UEFI BGRT (firmware logo)
# with a spinner. Functional, zero custom assets. Q33 branding can swap to
# a paco-branded theme later.

current_theme="$(plymouth-set-default-theme 2> /dev/null || echo none)"
if [[ "${current_theme}" == "bgrt" ]]; then
  echo "Plymouth already set to bgrt. Skipping."
  exit 0
fi

# -R rebuilds initramfs so the new theme takes effect on next boot
sudo plymouth-set-default-theme -R bgrt
echo "Plymouth theme set to bgrt (initramfs rebuilt)."
