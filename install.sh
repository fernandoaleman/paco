#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# paco install — master orchestrator (grows as install phases land).
# - SC1091: shellcheck-py can't resolve sourced paths that use variables
# - SC2154: PACO_INSTALL_LOG_FILE is set by helpers/logging.sh once sourced

set -euo pipefail

PACO_PATH="${PACO_PATH:-${HOME}/.local/share/paco}"
PACO_INSTALL="${PACO_PATH}/install"
export PACO_PATH PACO_INSTALL

# shellcheck source=install/helpers/all.sh
source "${PACO_INSTALL}/helpers/all.sh"

start_install_log
paco_banner
paco_section "Installing paco (iteration 3b — preflight + state markers)"

source "${PACO_INSTALL}/preflight/all.sh"

echo
paco_section "Preflight passed. (No further install phases yet — packaging lands in iter 6+.)"
echo "Log: ${PACO_INSTALL_LOG_FILE}"
