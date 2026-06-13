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

# Cleanup: an earlier paco version put the compose override under
# ~/.config/containers/containers.conf.d/ — podman doesn't scan that
# location, so the file was inert. Remove it if it's still there.
old_user_path="${XDG_CONFIG_HOME:-${HOME}/.config}/containers/containers.conf.d/99-paco-quiet.conf"
if [[ -L "${old_user_path}" || -f "${old_user_path}" ]]; then
  rm -f "${old_user_path}"
  echo "Removed stale user-level override at ${old_user_path}"
fi

# Quiet 2: podman compose's "Executing external compose provider" notice.
# Has to live in /etc/containers/containers.conf.d/ — podman doesn't
# scan a user-XDG .d/ override directory (only ~/.config/containers/
# containers.conf as a single file).
target="/etc/containers/containers.conf.d/99-paco-quiet.conf"
source_file="${PACO_PATH}/default/containers/containers.conf.d/99-paco-quiet.conf"

if [[ -f "${target}" ]] && cmp -s "${source_file}" "${target}"; then
  echo "${target} already in place."
  exit 0
fi

sudo install -Dm644 "${source_file}" "${target}"
echo "Installed ${target}"
