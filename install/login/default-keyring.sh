#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Creating passwordless Default keyring"

# Per Q22: paco's threat model is LUKS-encrypted disk + SDDM autologin,
# so the user has already proved physical possession at the LUKS prompt.
# Stacking another password-protected keyring on top is friction without
# real benefit — and without this step, Chrome (and any other Secret
# Service consumer) will pop up a "Choose password for new keyring"
# dialog on first launch.
#
# Ship a passwordless Default keyring file directly, matching omarchy's
# `default-keyring.sh` pattern (since we already stripped pam_gnome_keyring
# from /etc/pam.d/sddm in iter 15).
KEYRING_DIR="${HOME}/.local/share/keyrings"
KEYRING_FILE="${KEYRING_DIR}/Default_keyring.keyring"
DEFAULT_FILE="${KEYRING_DIR}/default"

mkdir -p "${KEYRING_DIR}"

# Idempotency: if the keyring file already exists, leave it alone — it
# may have been populated with real secrets we shouldn't overwrite.
if [[ -f ${KEYRING_FILE} ]] && [[ -f ${DEFAULT_FILE} ]]; then
  echo "Default_keyring already in place. Skipping."
else
  cat > "${KEYRING_FILE}" << EOF
[keyring]
display-name=Default keyring
ctime=$(date +%s)
mtime=0
lock-on-idle=false
lock-after=false
EOF

  cat > "${DEFAULT_FILE}" << EOF
Default_keyring
EOF

  echo "Wrote ${KEYRING_FILE}"
  echo "Wrote ${DEFAULT_FILE}"
fi

chmod 700 "${KEYRING_DIR}"
chmod 600 "${KEYRING_FILE}"
chmod 644 "${DEFAULT_FILE}"
