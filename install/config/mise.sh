#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring mise"

target_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/mise"
target="${target_dir}/config.toml"
source_file="${PACO_PATH}/default/mise/config.toml"

mkdir -p "${target_dir}"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "mise config already symlinked."
  exit 0
fi

if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_file}" "${target}"
echo "Symlinked ${target} → ${source_file}"
echo "(Run 'paco setup-nvim-providers' to install Python + Ruby + nvim provider bridge.)"
