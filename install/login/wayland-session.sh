#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing Wayland session entry"

target="/usr/local/share/wayland-sessions/paco.desktop"
source_file="${PACO_PATH}/default/wayland-sessions/paco.desktop"

if [[ -f "${target}" ]] && cmp -s "${source_file}" "${target}"; then
  echo "${target} already in place."
  exit 0
fi

sudo install -Dm644 "${source_file}" "${target}"
echo "Installed ${target}"
