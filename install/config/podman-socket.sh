#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Enabling user podman socket"

# Idempotency: skip if already enabled + active.
if systemctl --user is-enabled podman.socket > /dev/null 2>&1 &&
  systemctl --user is-active podman.socket > /dev/null 2>&1; then
  echo "podman.socket already enabled and active. Skipping."
  exit 0
fi

# `systemctl --user` requires an active user session bus. On a fresh SSH
# session without lingering it may not be available — fall back to a
# clear instruction rather than failing the entire install.
if ! systemctl --user enable --now podman.socket 2> /dev/null; then
  echo "WARN: Could not enable podman.socket — no user session bus yet?"
  echo "      Run this manually after your next login:"
  echo "        systemctl --user enable --now podman.socket"
  exit 0
fi

echo "podman.socket enabled and started."
