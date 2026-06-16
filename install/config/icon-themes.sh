#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing user-level icon overlays for bundled apps"

# Some AUR / extra packages ship .desktop files referencing icons by
# name (e.g. `Icon=zennotes`, `Icon=yazi`) but never actually drop the
# matching PNG into /usr/share/icons/hicolor/<size>/apps/ — either
# because the upstream tarball doesn't contain the right paths or
# because the AUR PKGBUILD's `if [ -f ]` check silently misses them.
# The result is a "?" placeholder in Vicinae for affected apps.
#
# paco bundles user-level overrides under default/icons/hicolor/, which
# we symlink into ~/.local/share/icons/hicolor/. Per the XDG icon-theme
# spec, user-level icons override system-level ones, so this works
# whether or not the upstream package shipped an icon.
src_root="${PACO_PATH}/default/icons/hicolor"
dst_root="${XDG_DATA_HOME:-${HOME}/.local/share}/icons/hicolor"

if [[ ! -d ${src_root} ]]; then
  echo "No bundled icons at ${src_root}. Skipping."
  exit 0
fi

# Mirror the hicolor tree structure under the user's icon dir, symlinking
# each PNG. Symlinks (vs copies) mean future paco updates that bump an
# icon take effect immediately without re-running this script.
while IFS= read -r -d '' src; do
  rel="${src#"${src_root}"/}"
  dst="${dst_root}/${rel}"
  mkdir -p "$(dirname "${dst}")"

  if [[ -L ${dst} ]] && [[ "$(readlink "${dst}")" == "${src}" ]]; then
    continue
  fi

  if [[ -e ${dst} ]] && [[ ! -L ${dst} ]]; then
    backup="${dst}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing ${dst} → ${backup}"
    mv "${dst}" "${backup}"
  fi

  ln -sfn "${src}" "${dst}"
  echo "Symlinked ${rel}"
done < <(find "${src_root}" -name '*.png' -print0)

# Refresh the icon cache so launchers (Vicinae included) pick up the
# new icons without a session restart. Best-effort — gtk-update-icon-cache
# is part of gtk-update-icon-cache package (deps of GTK stack); should
# always be present on a paco system but harmless if not.
if command -v gtk-update-icon-cache > /dev/null 2>&1; then
  gtk-update-icon-cache -q -t "${dst_root}" 2> /dev/null || true
  echo "Refreshed icon cache at ${dst_root}"
fi
