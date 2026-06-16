#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Registering default MIME handlers"

# Per iter 20c: route inode/directory to Thunar so opening a folder
# from any app (xdg-open ~/Documents, Vicinae file-browse extensions,
# etc.) lands in paco's chosen GUI file manager.
#
# xdg-mime is user-level (writes ~/.config/mimeapps.list); it's
# idempotent — `default` no-ops when the association is already set.
xdg-mime default thunar.desktop inode/directory
echo "inode/directory → thunar.desktop"
