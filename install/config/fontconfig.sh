#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring fontconfig defaults"

target_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/fontconfig"
target="${target_dir}/fonts.conf"
source_file="${PACO_PATH}/default/fontconfig/fonts.conf"

mkdir -p "${target_dir}"

# Idempotency: if already symlinked correctly, skip the link + cache refresh.
if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "fontconfig already symlinked. Skipping."
  exit 0
fi

# Back up any pre-existing non-symlink file.
if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${target} → ${backup}"
  mv "${target}" "${backup}"
fi

ln -sfn "${source_file}" "${target}"
echo "Symlinked ${target} → ${source_file}"

echo "Refreshing fontconfig cache..."
fc-cache -f
echo "Done."
