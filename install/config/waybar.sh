#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring Waybar"

target_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/waybar"
source_dir="${PACO_PATH}/default/waybar"

mkdir -p "$(dirname "${target_dir}")"

if [[ -L "${target_dir}" ]] && [[ "$(readlink "${target_dir}")" == "${source_dir}" ]]; then
  echo "Waybar config already symlinked."
  exit 0
fi

if [[ -e "${target_dir}" ]] && [[ ! -L "${target_dir}" ]]; then
  backup="${target_dir}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target_dir} → ${backup}"
  mv "${target_dir}" "${backup}"
fi

ln -sfn "${source_dir}" "${target_dir}"
echo "Symlinked ${target_dir} → ${source_dir}"
