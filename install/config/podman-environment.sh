#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring podman environment (~/.config/environment.d)"

target_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/environment.d"
target="${target_dir}/paco-podman.conf"
source_file="${PACO_PATH}/default/environment.d/paco-podman.conf"

mkdir -p "${target_dir}"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "podman environment.d file already symlinked."
  exit 0
fi

if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_file}" "${target}"
echo "Symlinked ${target} → ${source_file}"
echo "(Takes effect on next login or after: systemctl --user daemon-reload)"
