#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Installing docker-compose shim → podman-compose"

# Modern `docker compose` (space) already works via the podman-docker wrapper.
# This shim covers the legacy hyphenated form `docker-compose` that Makefiles,
# CI scripts, and older tutorials still use.

target="/usr/local/bin/docker-compose"
source_path="$(command -v podman-compose 2> /dev/null || true)"

if [[ -z "${source_path}" ]]; then
  echo "podman-compose not found. Skipping shim install."
  exit 0
fi

# Idempotency: skip if symlink already points where we want.
if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_path}" ]]; then
  echo "docker-compose shim already in place."
  exit 0
fi

# Don't clobber an existing file that isn't our symlink (e.g., if user
# installed the docker-compose pacman pkg directly).
if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
  echo "WARN: ${target} exists and isn't a paco symlink. Skipping."
  exit 0
fi

sudo ln -sfn "${source_path}" "${target}"
echo "Symlinked ${target} → ${source_path}"
