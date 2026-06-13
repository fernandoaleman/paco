#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring neovim (LazyVim)"

target="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim"
source_file="${PACO_PATH}/default/nvim"

mkdir -p "$(dirname "${target}")"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "nvim config already symlinked."
  exit 0
fi

if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_file}" "${target}"
echo "Symlinked ${target} → ${source_file}"
echo "(First nvim launch will bootstrap LazyVim — ~30-60s. Press q when the Lazy UI finishes.)"
