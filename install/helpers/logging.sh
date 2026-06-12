#!/usr/bin/env bash
# shellcheck disable=SC2154
# Logging: structured install log under XDG state dir.
# PACO_PATH / PACO_REF are set by install.sh before this is sourced.

PACO_STATE_DIR="${XDG_STATE_HOME:-${HOME}/.local/state}/paco"
PACO_INSTALL_LOG_FILE="${PACO_STATE_DIR}/install.log"

start_install_log() {
  mkdir -p "${PACO_STATE_DIR}"
  : > "${PACO_INSTALL_LOG_FILE}"
  {
    echo "=== paco install log ==="
    echo "Started:   $(date -Iseconds)"
    echo "PACO_PATH: ${PACO_PATH}"
    echo "PACO_REF:  ${PACO_REF:-master}"
    echo "User:      ${USER} ($(id -u))"
    echo "Host:      $(hostname)"
    echo "========================"
  } >> "${PACO_INSTALL_LOG_FILE}"
}

run_logged() {
  local script="$1"
  local name="${script##*/}"
  {
    echo
    echo "--- ${name} @ $(date -Iseconds) ---"
  } >> "${PACO_INSTALL_LOG_FILE}"
  bash "${script}" 2>&1 | tee -a "${PACO_INSTALL_LOG_FILE}"
}
