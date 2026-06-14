#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring Bluetooth"

# Enable + start bluetooth.service. The daemon needs to be running so
# blueman-applet (Hyprland autostart) can talk to it, and so paired
# bluetooth keyboards/mice reconnect automatically after autologin.
#
# We deliberately keep bluez's default `AutoEnable=true` (i.e. don't
# sed /etc/bluetooth/main.conf) so the controller powers on at every
# boot. Users with a BT keyboard/mouse otherwise need a wired keyboard
# to toggle the radio on each session — the LUKS prompt already forces
# wired-KB use once (initramfs has no bluetooth stack), and forcing it
# a second time post-login would be needlessly hostile to BT-KB users.
#
# Privacy-conscious users who want BT off at boot can flip the value
# back to false via blueman or by editing /etc/bluetooth/main.conf.
if systemctl is-enabled bluetooth.service > /dev/null 2>&1 &&
  systemctl is-active bluetooth.service > /dev/null 2>&1; then
  echo "bluetooth.service already enabled + active."
else
  sudo systemctl enable --now bluetooth.service
  echo "Enabled + started bluetooth.service."
fi

# Ship paco's wireplumber drop-in for A2DP auto-connect on bluetooth audio.
wp_target_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/wireplumber/wireplumber.conf.d"
wp_target="${wp_target_dir}/bluetooth-a2dp-autoconnect.conf"
wp_source="${PACO_PATH}/default/wireplumber/wireplumber.conf.d/bluetooth-a2dp-autoconnect.conf"

mkdir -p "${wp_target_dir}"

if [[ -L "${wp_target}" ]] && [[ "$(readlink "${wp_target}")" == "${wp_source}" ]]; then
  echo "Wireplumber A2DP drop-in already symlinked."
else
  if [[ -e "${wp_target}" ]] && [[ ! -L "${wp_target}" ]]; then
    backup="${wp_target}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing ${wp_target} → ${backup}"
    mv "${wp_target}" "${backup}"
  fi
  ln -sfn "${wp_source}" "${wp_target}"
  echo "Symlinked ${wp_target} → ${wp_source}"
fi
