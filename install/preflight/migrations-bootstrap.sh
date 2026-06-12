#!/usr/bin/env bash
# shellcheck disable=SC2154
set -euo pipefail

# Q41: On fresh installs, mark existing migrations as already-applied
# (they migrate existing installs forward, not run on greenfield).

PACO_MIGRATIONS="${PACO_PATH}/migrations"
PACO_MIGRATIONS_STATE="${PACO_STATE_DIR}/migrations"
mkdir -p "${PACO_MIGRATIONS_STATE}"

if [[ -f "${PACO_STATE_DIR}/migrations-bootstrapped" ]]; then
  echo "Migrations already bootstrapped. Skipping."
  exit 0
fi

if [[ -d "${PACO_MIGRATIONS}" ]]; then
  count=0
  for migration in "${PACO_MIGRATIONS}/"*.sh; do
    [[ -f "${migration}" ]] || continue
    name="$(basename "${migration}")"
    touch "${PACO_MIGRATIONS_STATE}/${name}.applied"
    ((count++))
  done
  echo "Migrations bootstrapped: ${count} marked as already-applied."
else
  echo "No migrations directory yet. Bootstrap is a no-op."
fi

touch "${PACO_STATE_DIR}/migrations-bootstrapped"
