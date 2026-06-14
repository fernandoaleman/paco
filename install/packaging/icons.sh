#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing bundled app icons (~/.local/share/applications/icons)"

# Bundled PNG files are shipped under ${PACO_PATH}/applications/icons/ and
# copied into the user-local icons dir at install time. webapps.sh (and
# any later paco-webapp-install calls) look up icons by filename in
# the destination dir.
src_dir="${PACO_PATH}/applications/icons"
dst_dir="${HOME}/.local/share/applications/icons"

if [[ ! -d ${src_dir} ]]; then
  echo "Source icon dir ${src_dir} not found. Skipping."
  exit 0
fi

mkdir -p "${dst_dir}"

# cp -u skips files that haven't changed — idempotent re-runs print
# nothing and produce no work.
cp -u "${src_dir}"/*.png "${dst_dir}/" 2> /dev/null || true

echo "Synced icons: $(find "${src_dir}" -maxdepth 1 -name '*.png' | wc -l) bundled → ${dst_dir}"
