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
  echo "UFW already active with paco defaults. Skipping."
else
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw --force enable
  echo "UFW enabled (deny incoming / allow outgoing)."
fi

# Make sure UFW comes up on boot.
if systemctl is-enabled ufw.service > /dev/null 2>&1; then
  echo "ufw.service already enabled."
else
  sudo systemctl enable ufw.service
  echo "Enabled ufw.service."
fi
