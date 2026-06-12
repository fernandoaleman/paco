#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

# 1. Vanilla Arch Linux
if [[ ! -f /etc/arch-release ]]; then
  paco_abort "paco requires Arch Linux. /etc/arch-release not found."
fi

# 2. x86_64 architecture
if [[ "$(uname -m)" != "x86_64" ]]; then
  paco_abort "paco requires x86_64. Found: $(uname -m)"
fi

# 3. UEFI boot mode (not BIOS)
if [[ ! -d /sys/firmware/efi ]]; then
  paco_abort "paco requires UEFI boot. /sys/firmware/efi missing (BIOS detected)."
fi

# 4. btrfs root filesystem (Q43 hard requirement)
root_fs="$(findmnt -no FSTYPE /)"
if [[ "${root_fs}" != "btrfs" ]]; then
  paco_abort "paco requires btrfs root. Found: ${root_fs}. Reinstall with archinstall + btrfs."
fi

# 5. Limine bootloader present (Q24)
if [[ ! -e /boot/limine.conf ]] && [[ ! -d /boot/EFI/limine ]] && [[ ! -d /boot/EFI/BOOT ]]; then
  paco_abort "Limine bootloader not detected at /boot. paco requires Limine."
fi

# 6. Not running as root (paco-pkg-add invokes sudo internally)
if [[ "$(id -u)" -eq 0 ]]; then
  paco_abort "Do not run paco install as root. Run as your user; sudo is invoked when needed."
fi

echo "All system guards passed."
