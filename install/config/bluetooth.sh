#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring Bluetooth"

# Enable bluetooth.service (NOT --now). User toggles power on/off via
# waybar bluetooth module / blueman-applet; we don't want the radio
# blasting at boot.
if systemctl is-enabled bluetooth.service > /dev/null 2>&1; then
  echo "bluetooth.service already enabled."
else
  sudo systemctl enable bluetooth.service
  echo "Enabled bluetooth.service."
fi

# Persist last power state across reboots (default AutoEnable=true would
# always power-on at boot, overriding the user's last choice).
bt_main_conf="/etc/bluetooth/main.conf"
if [[ -f "${bt_main_conf}" ]]; then
  if grep -qE '^AutoEnable=false$' "${bt_main_conf}"; then
    echo "${bt_main_conf} already has AutoEnable=false."
  else
    sudo sed -i 's/^#\?AutoEnable=.*/AutoEnable=false/' "${bt_main_conf}"
    echo "Set AutoEnable=false in ${bt_main_conf}."
  fi
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
