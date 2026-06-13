#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Relaxing faillock for SDDM autologin"

# Without this, autologin events on /etc/pam.d/sddm-autologin can
# accumulate as failures and lock the user out. Per omarchy's pattern:
#   - Remove the `preauth` faillock check (so autologin events don't
#     get counted).
#   - Add an `authsucc` line after pam_permit (so a successful
#     autologin resets the lockout counter).

target="/etc/pam.d/sddm-autologin"

if [[ ! -f "${target}" ]]; then
  echo "${target} not found (SDDM not installed?). Skipping."
  exit 0
fi

changed=0

if grep -q '^[[:space:]]*auth[[:space:]]\+required[[:space:]]\+pam_faillock\.so[[:space:]]*preauth' "${target}"; then
  sudo sed -i '/^[[:space:]]*auth[[:space:]]\+required[[:space:]]\+pam_faillock\.so[[:space:]]*preauth/d' "${target}"
  changed=1
fi

if ! grep -q 'pam_faillock\.so[[:space:]]*authsucc' "${target}"; then
  sudo sed -i '/auth.*pam_permit\.so/a auth        required    pam_faillock.so authsucc' "${target}"
  changed=1
fi

if [[ ${changed} -eq 0 ]]; then
  echo "${target} already adjusted. Skipping."
else
  echo "Adjusted faillock entries in ${target}."
fi
