#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring SDDM (autologin + Wayland)"

user="$(id -un)"

# 1. Install paco's stripped Hyprland config for SDDM's own greeter.
src_hyprland_lua="${PACO_PATH}/default/sddm/hyprland.lua"
dest_hyprland_lua="/usr/share/sddm/hyprland.lua"

if [[ -f "${dest_hyprland_lua}" ]] && cmp -s "${src_hyprland_lua}" "${dest_hyprland_lua}"; then
  echo "${dest_hyprland_lua} already in place."
else
  sudo install -Dm644 "${src_hyprland_lua}" "${dest_hyprland_lua}"
  echo "Installed ${dest_hyprland_lua}"
fi

# 2. Remove stale /usr/share/sddm/hyprland.conf if it exists (SDDM
#    would otherwise prefer it over our .lua).
if [[ -f /usr/share/sddm/hyprland.conf ]]; then
  sudo rm -f /usr/share/sddm/hyprland.conf
  echo "Removed stale /usr/share/sddm/hyprland.conf"
fi

# 3. /etc/sddm.conf.d/10-wayland.conf — tells SDDM to render itself
#    under Wayland via Hyprland.
sudo mkdir -p /etc/sddm.conf.d

wayland_target="/etc/sddm.conf.d/10-wayland.conf"
wayland_tmp="$(mktemp)"
trap 'rm -f "${wayland_tmp}"' EXIT

cat > "${wayland_tmp}" << 'EOF'
[General]
DisplayServer=wayland

[Wayland]
CompositorCommand=start-hyprland -- --config /usr/share/sddm/hyprland.lua
EOF

if [[ -f "${wayland_target}" ]] && cmp -s "${wayland_tmp}" "${wayland_target}"; then
  echo "${wayland_target} already in place."
else
  sudo install -Dm644 "${wayland_tmp}" "${wayland_target}"
  echo "Wrote ${wayland_target}"
fi

# 4. /etc/sddm.conf.d/autologin.conf — auto-log this user into the paco session.
autologin_target="/etc/sddm.conf.d/autologin.conf"
autologin_tmp="$(mktemp)"
# extend the EXIT trap to also clean this up
trap 'rm -f "${wayland_tmp}" "${autologin_tmp}"' EXIT

cat > "${autologin_tmp}" << EOF
[Autologin]
User=${user}
Session=paco
EOF

if [[ -f "${autologin_target}" ]] && cmp -s "${autologin_tmp}" "${autologin_target}"; then
  echo "${autologin_target} already in place (User=${user})."
else
  sudo install -Dm644 "${autologin_tmp}" "${autologin_target}"
  echo "Wrote ${autologin_target} (User=${user})"
fi

# 5. Strip pam_gnome_keyring from /etc/pam.d/sddm so SDDM autologin
#    doesn't try to set up an encrypted login keyring (Q22 pattern;
#    relies on a passwordless Default_keyring for the desktop session).
#    Only strips -auth and -password phases — the -session phase
#    legitimately keeps pam_gnome_keyring (to start the daemon).
if grep -qE '^-(auth|password).*pam_gnome_keyring\.so' /etc/pam.d/sddm 2> /dev/null; then
  sudo sed -i '/-auth.*pam_gnome_keyring\.so/d' /etc/pam.d/sddm
  sudo sed -i '/-password.*pam_gnome_keyring\.so/d' /etc/pam.d/sddm
  echo "Stripped pam_gnome_keyring -auth/-password from /etc/pam.d/sddm"
else
  echo "pam_gnome_keyring -auth/-password already stripped."
fi

# 6. Enable SDDM. Intentionally NOT --now — activates on next reboot.
if systemctl is-enabled sddm.service > /dev/null 2>&1; then
  echo "sddm.service already enabled."
else
  sudo systemctl enable sddm.service
  echo "Enabled sddm.service (activates on next reboot)."
fi
