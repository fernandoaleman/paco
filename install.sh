#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# paco install — master orchestrator (grows as install phases land).
# - SC1091: shellcheck-py can't resolve sourced paths that use variables
# - SC2154: PACO_INSTALL_LOG_FILE is set by helpers/logging.sh once sourced

set -euo pipefail

PACO_PATH="${PACO_PATH:-${HOME}/.local/share/paco}"
PACO_INSTALL="${PACO_PATH}/install"
export PACO_PATH PACO_INSTALL

# Make paco-* subcommands available for this install session by prepending
# the clone's bin/ to PATH. After install completes, /etc/profile.d/paco.sh
# (installed by post-install/paco-profile.sh) puts /usr/share/paco/bin on
# PATH for future shells.
export PATH="${PACO_PATH}/bin:${PATH}"

# shellcheck source=install/helpers/all.sh
source "${PACO_INSTALL}/helpers/all.sh"

start_install_log
paco_banner
paco_section "Installing paco (iteration 13c — nvim + LazyVim)"

source "${PACO_INSTALL}/preflight/all.sh"
source "${PACO_INSTALL}/packaging/all.sh"
source "${PACO_INSTALL}/config/all.sh"
source "${PACO_INSTALL}/post-install/all.sh"
