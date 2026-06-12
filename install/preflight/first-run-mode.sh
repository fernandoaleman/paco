#!/usr/bin/env bash
# shellcheck disable=SC2154
set -euo pipefail

# Marker that first-run scripts should execute on next desktop login.
# Removed by cleanup-reboot-sudoers.sh after first-run completes (iter 21).
mkdir -p "${PACO_STATE_DIR}"
touch "${PACO_STATE_DIR}/first-run.mode"
echo "First-run mode armed at ${PACO_STATE_DIR}/first-run.mode"
