#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing boot stack (Plymouth + Limine + snapper)"

# plymouth:                graphical boot splash
# snapper:                 btrfs snapshot manager (root-only per Q43)
# limine-snapper-sync:     auto-create snapshots + populate Limine boot menu
# limine-mkinitcpio-hook:  rebuild UKI + update Limine entries on kernel/initrd changes
TOOLS=(plymouth snapper limine-snapper-sync limine-mkinitcpio-hook)

missing=()
for t in "${TOOLS[@]}"; do
  paco-pkg-present "${t}" || missing+=("${t}")
done

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "Boot stack already installed. Skipping."
  exit 0
fi

paco-pkg-add "${missing[@]}"
echo "Boot stack installed: ${TOOLS[*]}"
