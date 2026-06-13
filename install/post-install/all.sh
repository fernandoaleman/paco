#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# Post-install: anything that happens after preflight + (eventually) packaging.

PACO_POST="${PACO_INSTALL}/post-install"

run_logged "${PACO_POST}/paco-install.sh"
run_logged "${PACO_POST}/paco-profile.sh"
run_logged "${PACO_POST}/pacman-config.sh"
run_logged "${PACO_POST}/docker-compose-shim.sh"
run_logged "${PACO_POST}/finished.sh"
