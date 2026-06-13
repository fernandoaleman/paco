#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# Config phase: wire up user-facing app configs.

PACO_CONFIG="${PACO_INSTALL}/config"

run_logged "${PACO_CONFIG}/zsh-layout.sh"
