#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# Login phase: desktop session entries, login managers (SDDM lands in iter 15).

PACO_LOGIN="${PACO_INSTALL}/login"

run_logged "${PACO_LOGIN}/wayland-session.sh"
run_logged "${PACO_LOGIN}/sddm.sh"
run_logged "${PACO_LOGIN}/faillock-sddm.sh"
run_logged "${PACO_LOGIN}/plymouth.sh"
run_logged "${PACO_LOGIN}/limine-snapper.sh"
