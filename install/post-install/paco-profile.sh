#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Adding /usr/share/paco/bin to system PATH"

PROFILE_FILE="/etc/profile.d/paco.sh"

# Render the expected file into a tempfile for byte-exact comparison.
expected="$(mktemp)"
trap 'rm -f "${expected}"' EXIT

cat > "${expected}" << 'EOF'
# Add paco subcommands to PATH for interactive shells.
case ":${PATH}:" in
  *":/usr/share/paco/bin:"*) ;;
  *) export PATH="${PATH}:/usr/share/paco/bin" ;;
esac
EOF

# Idempotency: skip if file is already in desired state.
if [[ -f "${PROFILE_FILE}" ]] && cmp -s "${expected}" "${PROFILE_FILE}"; then
  echo "Profile script already in place. Skipping."
  exit 0
fi

sudo install -Dm644 "${expected}" "${PROFILE_FILE}"
echo "Profile script installed at ${PROFILE_FILE}"
echo "(Takes effect on next login; current install session already has PACO_PATH/bin on PATH.)"
