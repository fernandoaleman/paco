#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring fontconfig defaults"

# Ensure fontconfig is installed (provides fc-cache, fc-match, fc-list).
# Font *files* don't pull this in — only font *consumers* do, so on a minimal
# Arch base we have to add it explicitly.
if ! paco-pkg-present fontconfig; then
  paco-pkg-add fontconfig
fi

target_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/fontconfig"
target="${target_dir}/fonts.conf"
source_file="${PACO_PATH}/default/fontconfig/fonts.conf"

mkdir -p "${target_dir}"

# Idempotency for the symlink itself.
if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "fontconfig symlink already in place."
else
  if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
    backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing ${target} → ${backup}"
    mv "${target}" "${backup}"
  fi
  ln -sfn "${source_file}" "${target}"
  echo "Symlinked ${target} → ${source_file}"
fi

# Always refresh cache — cheap, and ensures it runs even if the symlink was
# created in a prior (failed) run.
echo "Refreshing fontconfig cache..."
fc-cache -f > /dev/null
echo "Done."
