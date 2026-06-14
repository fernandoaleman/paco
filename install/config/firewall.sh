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

# UFW's rule files (/etc/ufw/user.rules) are root-only, so `ufw status`
# always needs sudo — which would prompt for a password on every paco
# update. To stay quiet on idempotent re-runs, short-circuit on three
# cheap, sudo-free signals:
#   (1) /etc/ufw/ufw.conf has ENABLED=yes (world-readable),
#   (2) ufw.service is enabled + active, and
#   (3) paco's own state marker exists (we drop it after a successful
#       initial configure below).
firewall_marker="${PACO_STATE_DIR}/firewall.applied"

if grep -qE '^ENABLED=yes' /etc/ufw/ufw.conf 2> /dev/null &&
  systemctl is-enabled ufw.service > /dev/null 2>&1 &&
  systemctl is-active ufw.service > /dev/null 2>&1 &&
  [[ -f ${firewall_marker} ]]; then
  echo "UFW already configured + active (paco marker present). Skipping."
  exit 0
fi

# Slow path: actually touch UFW. Capture status once so subsequent
# checks in this run don't re-prompt for sudo.
status_output="$(sudo ufw status verbose 2>&1 || true)"

if grep -q '^Status: active' <<< "${status_output}" &&
  grep -q '^Default: deny (incoming), allow (outgoing)' <<< "${status_output}"; then
  echo "UFW already active with paco defaults. Skipping baseline."
else
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw --force enable
  echo "UFW enabled (deny incoming / allow outgoing)."
  # Refresh status_output now that rules + state may have changed.
  status_output="$(sudo ufw status verbose 2>&1 || true)"
fi

# If openssh is installed, allow inbound SSH. paco's threat model is
# dev-focused — most users want SSH-in from a paired workstation, and
# default-deny without an SSH exception would lock out the rescue path
# the implementation plan relies on. Re-uses the cached status_output
# so no extra sudo call is needed.
if pacman -Qq openssh > /dev/null 2>&1; then
  if grep -qE '^22(/tcp)?[[:space:]]+ALLOW' <<< "${status_output}"; then
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

# Drop paco state marker so the next paco update takes the no-sudo
# fast path. Mirrors the existing PACO_STATE_DIR pattern used by
# preflight scripts (first-run.mode, migrations-bootstrapped).
mkdir -p "${PACO_STATE_DIR}"
touch "${firewall_marker}"
