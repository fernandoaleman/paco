#!/usr/bin/env bash
# Error handling: trap ERR, print log tail + gum-styled error.

set -E
trap 'paco_handle_error $? $LINENO' ERR

paco_handle_error() {
  local exit_code="$1"
  local line_no="$2"
  echo
  gum style --foreground "#f38ba8" --bold \
    "✗ paco install failed at line ${line_no} (exit ${exit_code})"
  if [[ -r "${PACO_INSTALL_LOG_FILE:-}" ]]; then
    echo
    echo "Last 20 log lines (${PACO_INSTALL_LOG_FILE}):"
    tail -n 20 "${PACO_INSTALL_LOG_FILE}"
  fi
  exit "${exit_code}"
}

paco_abort() {
  gum style --foreground "#f38ba8" --bold "✗ $1"
  exit 1
}
