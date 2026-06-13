#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring git defaults (delta pager)"

target_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/git"
target="${target_dir}/config"
source_file="${PACO_PATH}/default/git/config"

mkdir -p "${target_dir}"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "git config already symlinked."
  exit 0
fi

if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_file}" "${target}"
echo "Symlinked ${target} → ${source_file}"
echo "(~/.gitconfig untouched — XDG config layers on top.)"
