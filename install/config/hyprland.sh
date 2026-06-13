#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring Hyprland (~/.config/hypr)"

target="${XDG_CONFIG_HOME:-${HOME}/.config}/hypr"
source_dir="${PACO_PATH}/default/hypr-user"

mkdir -p "$(dirname "${target}")"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_dir}" ]]; then
  echo "Hyprland config already symlinked."
  exit 0
fi

if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_dir}" "${target}"
echo "Symlinked ${target} → ${source_dir}"
