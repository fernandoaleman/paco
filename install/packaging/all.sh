#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# Packaging phase: install pacman + AUR packages.

PACO_PACKAGING="${PACO_INSTALL}/packaging"

run_logged "${PACO_PACKAGING}/yay.sh"
