#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring starship prompt"

target="${XDG_CONFIG_HOME:-${HOME}/.config}/starship.toml"
source_file="${PACO_PATH}/default/starship/starship.toml"

mkdir -p "$(dirname "${target}")"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "starship config already symlinked."
  exit 0
fi

if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_file}" "${target}"
echo "Symlinked ${target} → ${source_file}"
