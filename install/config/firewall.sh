#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring firewall (UFW default deny incoming)"

# Per Q27 + Q44: ship UFW with default-deny incoming, default-allow
# outgoing. Standard desktop hardening; users open ports themselves
# via `sudo ufw allow ...` if they need to.
#
# omarchy bundles LocalSend ports + ufw-docker; paco skips both —
# LocalSend is not in our bundled apps (Q19/Q20) and we use podman
# rather than docker, so ufw-docker would just be dead weight.

# Idempotency-gated: only touch UFW if it's not already active +
# configured the way we want. `ufw status verbose` is the cheapest
# probe.
status_output="$(sudo ufw status verbose 2>&1 || true)"

if grep -q '^Status: active' <<< "${status_output}" &&
  grep -q '^Default: deny (incoming), allow (outgoing)' <<< "${status_output}"; then
  echo "UFW already active with paco defaults. Skipping baseline."
else
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw --force enable
  echo "UFW enabled (deny incoming / allow outgoing)."
fi

# If openssh is installed, allow inbound SSH. paco's threat model is
# dev-focused — most users want SSH-in from a paired workstation, and
# default-deny without an SSH exception would lock out the rescue path
# the implementation plan relies on.
if pacman -Qq openssh > /dev/null 2>&1; then
  if sudo ufw status | grep -qE '^22(/tcp)?[[:space:]]+ALLOW'; then
    echo "UFW already allows SSH."
  else
    sudo ufw allow ssh
    echo "UFW: allowed inbound SSH (openssh is installed)."
  fi
fi

# Make sure UFW comes up on boot AND is started in this session so
# `systemctl is-active` reports correctly.
if systemctl is-enabled ufw.service > /dev/null 2>&1 &&
  systemctl is-active ufw.service > /dev/null 2>&1; then
  echo "ufw.service already enabled + active."
else
  sudo systemctl enable --now ufw.service
  echo "Enabled + started ufw.service."
fi
