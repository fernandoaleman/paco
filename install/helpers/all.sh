#!/usr/bin/env bash
# shellcheck disable=SC1091
# Source every helper script in order. Helpers must source/run idempotently.

PACO_PATH="${PACO_PATH:-${HOME}/.local/share/paco}"
PACO_INSTALL="${PACO_INSTALL:-${PACO_PATH}/install}"

# Bootstrap: ensure gum is installed before any helper can use it for styling.
if ! command -v gum > /dev/null 2>&1; then
  echo "==> Installing gum (used for styled install output)..."
  sudo pacman -S --needed --noconfirm gum
fi

# shellcheck source=errors.sh
source "${PACO_INSTALL}/helpers/errors.sh"
# shellcheck source=logging.sh
source "${PACO_INSTALL}/helpers/logging.sh"
# shellcheck source=presentation.sh
source "${PACO_INSTALL}/helpers/presentation.sh"
# shellcheck source=chroot.sh
source "${PACO_INSTALL}/helpers/chroot.sh"

# Export so children started via `bash script.sh` can use them.
export PACO_PATH PACO_INSTALL PACO_STATE_DIR PACO_INSTALL_LOG_FILE
export PACO_ANSI_RED PACO_ANSI_RESET
export -f paco_section paco_banner paco_abort paco_handle_error
export -f start_install_log run_logged
