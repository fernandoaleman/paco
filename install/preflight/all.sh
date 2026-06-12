#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# Preflight orchestrator. Any child failure aborts before packaging.
# PACO_INSTALL and run_logged are exported by helpers/all.sh.

PACO_PREFLIGHT="${PACO_INSTALL}/preflight"

run_logged "${PACO_PREFLIGHT}/begin.sh"
run_logged "${PACO_PREFLIGHT}/show-env.sh"
run_logged "${PACO_PREFLIGHT}/guard.sh"
run_logged "${PACO_PREFLIGHT}/hardware-mins.sh"
run_logged "${PACO_PREFLIGHT}/git-author.sh"
run_logged "${PACO_PREFLIGHT}/first-run-mode.sh"
run_logged "${PACO_PREFLIGHT}/migrations-bootstrap.sh"
