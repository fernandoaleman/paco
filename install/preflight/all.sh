#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# Preflight orchestrator. Any child failure aborts before packaging.
# PACO_INSTALL and run_logged are exported by helpers/all.sh.

PACO_PREFLIGHT="${PACO_INSTALL}/preflight"

run_logged "${PACO_PREFLIGHT}/begin.sh"
run_logged "${PACO_PREFLIGHT}/show-env.sh"
run_logged "${PACO_PREFLIGHT}/guard.sh"
