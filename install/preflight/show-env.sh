#!/usr/bin/env bash
# shellcheck disable=SC2154
# PACO_* vars are exported by helpers/all.sh.
set -euo pipefail

echo "PACO_PATH:          ${PACO_PATH}"
echo "PACO_INSTALL:       ${PACO_INSTALL}"
echo "PACO_STATE_DIR:     ${PACO_STATE_DIR}"
echo "PACO_INSTALL_LOG:   ${PACO_INSTALL_LOG_FILE}"
echo "PACO_REF:           ${PACO_REF:-master}"
echo "PACO_REPO:          ${PACO_REPO:-fernandoaleman/paco}"
echo "User:               ${USER} ($(id -u))"
echo "Architecture:       $(uname -m)"
echo "Kernel:             $(uname -r)"
