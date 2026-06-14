#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring Limine bootloader + snapper + mkinitcpio"

# Hard requirement: Limine bootloader must be present (per Q24 + Q38 install
# guide). If not, archinstall didn't pick it — this iter can't proceed.
if ! command -v limine > /dev/null 2>&1; then
  echo "ERROR: limine not installed. paco requires Limine as bootloader." >&2
  echo "       Re-install Arch with Limine bootloader selected in archinstall." >&2
  exit 1
fi

# 1. mkinitcpio HOOKS — drop-in file that overrides the main config's HOOKS.
#    Per Q22 + Q23: plymouth needs to be in HOOKS for splash to render
#    during LUKS unlock + boot.
hooks_target="/etc/mkinitcpio.conf.d/paco_hooks.conf"
hooks_tmp="$(mktemp)"
trap 'rm -f "${hooks_tmp}"' EXIT

cat > "${hooks_tmp}" << 'EOF'
HOOKS=(base udev plymouth keyboard autodetect microcode modconf kms keymap consolefont block encrypt lvm2 filesystems fsck btrfs-overlayfs)
EOF

if [[ -f "${hooks_target}" ]] && cmp -s "${hooks_tmp}" "${hooks_target}"; then
  echo "${hooks_target} already in place."
  hooks_changed=0
else
  sudo install -Dm644 "${hooks_tmp}" "${hooks_target}"
  echo "Wrote ${hooks_target}"
  hooks_changed=1
fi

# 2. Find existing Limine config location (archinstall puts it in different
#    places depending on UEFI/BIOS + the chosen ESP path).
if [[ -f /boot/EFI/arch-limine/limine.conf ]]; then
  limine_config="/boot/EFI/arch-limine/limine.conf"
elif [[ -f /boot/EFI/BOOT/limine.conf ]]; then
  limine_config="/boot/EFI/BOOT/limine.conf"
elif [[ -f /boot/EFI/limine/limine.conf ]]; then
  limine_config="/boot/EFI/limine/limine.conf"
elif [[ -f /boot/limine/limine.conf ]]; then
  limine_config="/boot/limine/limine.conf"
elif [[ -f /boot/limine.conf ]]; then
  limine_config="/boot/limine.conf"
else
  echo "ERROR: Limine config not found in any expected location." >&2
  exit 1
fi

# 3. Extract the current kernel cmdline from the existing config so we don't
#    lose LUKS/root/rootflags arguments.
cmdline="$(grep "^[[:space:]]*cmdline:" "${limine_config}" |
  head -1 |
  sed 's/^[[:space:]]*cmdline:[[:space:]]*//')"

if [[ -z "${cmdline}" ]]; then
  echo "WARN: Could not extract cmdline from ${limine_config}. Boot may break." >&2
fi

# 4. Write /etc/default/limine from paco's template with the cmdline substituted.
#    This MUST happen before installing limine-mkinitcpio-hook (its post-tx hook
#    runs limine-install which reads /etc/default/limine).
default_target="/etc/default/limine"
default_tmp="$(mktemp)"
trap 'rm -f "${hooks_tmp}" "${default_tmp}"' EXIT

sed "s|@@CMDLINE@@|${cmdline}|g" "${PACO_PATH}/default/limine/default.conf" \
  > "${default_tmp}"

if [[ -f "${default_target}" ]] && cmp -s "${default_tmp}" "${default_target}"; then
  echo "${default_target} already in place."
else
  sudo install -Dm644 "${default_tmp}" "${default_target}"
  echo "Wrote ${default_target}"
fi

# Append any drop-in cmdline configs from /etc/limine-entry-tool.d/*.conf
# (hardware fix scripts in later iters can add files here).
shopt -s nullglob
for dropin in /etc/limine-entry-tool.d/*.conf; do
  # cat as user (dropins are typically world-readable), pipe to sudo tee -a.
  # Avoids SC2024 "sudo doesn't affect redirects" while preserving intent.
  cat "${dropin}" | sudo tee -a "${default_target}" > /dev/null
done
shopt -u nullglob

# 5. Remove the old in-ESP config if it's not /boot/limine.conf (avoid
#    conflicting configs on the same ESP).
if [[ "${limine_config}" != "/boot/limine.conf" && -f "${limine_config}" ]]; then
  sudo rm "${limine_config}"
  echo "Removed stale ${limine_config}"
fi

# 6. Install paco's branded /boot/limine.conf.
#    The boot entries (`/+ ...` lines) will be appended by limine-update.
paco_limine_conf="${PACO_PATH}/default/limine/limine.conf"
boot_limine_conf="/boot/limine.conf"

if [[ -f "${boot_limine_conf}" ]] &&
  head -20 "${boot_limine_conf}" | cmp -s "${paco_limine_conf}" - 2> /dev/null; then
  echo "${boot_limine_conf} (header) already paco-branded."
else
  sudo cp "${paco_limine_conf}" "${boot_limine_conf}"
  echo "Wrote ${boot_limine_conf} (entries will be appended by limine-update)"
fi

# 7. snapper for /. Skip if /home is btrfs (paco doesn't snapshot /home per Q43).
if ! sudo snapper list-configs 2> /dev/null | grep -q "root"; then
  echo "Creating snapper root config..."
  sudo snapper -c root create-config /
fi

# Overwrite with paco's snapper config (cmp-s gated for idempotency).
paco_snapper_root="${PACO_PATH}/default/snapper/root"
sys_snapper_root="/etc/snapper/configs/root"
if [[ -f "${sys_snapper_root}" ]] && cmp -s "${paco_snapper_root}" "${sys_snapper_root}"; then
  echo "${sys_snapper_root} already in place."
else
  sudo cp "${paco_snapper_root}" "${sys_snapper_root}"
  echo "Wrote ${sys_snapper_root}"
fi

# 8. Disable btrfs quotas — full qgroup accounting is a major perf drag,
#    and snapper works fine without it. Idempotent.
sudo btrfs quota disable / 2> /dev/null || true

# 9. Enable limine-snapper-sync.service (NOT --now; activates after reboot).
if systemctl is-enabled limine-snapper-sync.service > /dev/null 2>&1; then
  echo "limine-snapper-sync.service already enabled."
else
  sudo systemctl enable limine-snapper-sync.service
  echo "Enabled limine-snapper-sync.service."
fi

# 10. Run limine-update if /boot/limine.conf doesn't yet have boot entries.
#     The limine-mkinitcpio-hook would have run during package install and
#     populated entries already — this is a fallback.
if ! grep -q "^/+" "${boot_limine_conf}"; then
  echo "Running limine-update to populate boot entries..."
  sudo limine-update
fi

if ! grep -q "^/+" "${boot_limine_conf}"; then
  echo "ERROR: ${boot_limine_conf} has no boot entries (^/+ lines)." >&2
  echo "       System may not boot. Check sudo limine-update output." >&2
  exit 1
fi

echo "Limine + snapper + mkinitcpio configured."
echo "(Changes take effect on next reboot.)"

# Rebuild initramfs if we changed the HOOKS file. This is what makes plymouth
# actually run during boot.
if [[ ${hooks_changed} -eq 1 ]]; then
  echo "Rebuilding initramfs (HOOKS changed)..."
  sudo mkinitcpio -P
fi
