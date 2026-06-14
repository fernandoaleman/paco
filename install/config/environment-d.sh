#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Wiring paco bin into the systemd-user environment"

# `~/.config/environment.d/*.conf` is read by `systemd --user` at session
# start. Putting /usr/share/paco/bin on PATH here makes every .desktop
# Exec= line resolvable in a Wayland session (Vicinae, waybar exec
# directives, autostart, etc) — not just login shells.
target_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/environment.d"
target="${target_dir}/paco.conf"
source_file="${PACO_PATH}/default/environment.d/paco.conf"

mkdir -p "${target_dir}"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "environment.d/paco.conf already symlinked."
  exit 0
fi

if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_file}" "${target}"
echo "Symlinked ${target} → ${source_file}"
echo "(Takes effect on next login. To activate now: \`systemctl --user daemon-reload\` + restart affected services.)"
