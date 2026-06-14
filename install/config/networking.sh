#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring networking (NetworkManager)"

# Enable + start NetworkManager. archinstall typically enables it already
# (Q27, paco deviation from omarchy's iwd) but is-active gate keeps this
# safe for first install + re-runs.
if systemctl is-enabled NetworkManager.service > /dev/null 2>&1; then
  echo "NetworkManager.service already enabled."
else
  sudo systemctl enable NetworkManager.service
  echo "Enabled NetworkManager.service."
fi

if systemctl is-active NetworkManager.service > /dev/null 2>&1; then
  echo "NetworkManager.service already active."
else
  sudo systemctl start NetworkManager.service
  echo "Started NetworkManager.service."
fi

# Mask systemd-networkd-wait-online — without this it can hang boot for
# ~2 min waiting for an interface NetworkManager owns. (omarchy pattern.)
#
# `systemctl is-enabled` prints "masked" but exits 1 for masked units;
# with `set -o pipefail` upstream, piping into grep would inherit the
# nonzero exit even on a successful match. Capture into a variable
# instead so the comparison stands on its own.
mask_status="$(systemctl is-enabled systemd-networkd-wait-online.service 2> /dev/null || true)"
if [[ ${mask_status} == "masked" ]]; then
  echo "systemd-networkd-wait-online.service already masked."
else
  sudo systemctl disable systemd-networkd-wait-online.service 2> /dev/null || true
  sudo systemctl mask systemd-networkd-wait-online.service
  echo "Masked systemd-networkd-wait-online.service."
fi
