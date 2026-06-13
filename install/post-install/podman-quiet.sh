#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Quieting podman wrapper messages"

# Quiet 1: podman-docker's "Emulate Docker CLI using podman" notice.
# The wrapper checks /etc/containers/nodocker — empty file is enough.
if [[ -e /etc/containers/nodocker ]]; then
  echo "/etc/containers/nodocker already present."
else
  sudo touch /etc/containers/nodocker
  echo "Created /etc/containers/nodocker."
fi

# Quiet 2: podman compose's "Executing external compose provider" notice.
# Per-user containers.conf.d override (no /etc/ touching for this one).
user_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/containers/containers.conf.d"
target="${user_dir}/99-paco-quiet.conf"
source_file="${PACO_PATH}/default/containers/containers.conf.d/99-paco-quiet.conf"

mkdir -p "${user_dir}"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "containers.conf.d override already symlinked."
  exit 0
fi

if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_file}" "${target}"
echo "Symlinked ${target} → ${source_file}"
