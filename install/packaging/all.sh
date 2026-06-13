#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# Packaging phase: install pacman + AUR packages.

PACO_PACKAGING="${PACO_INSTALL}/packaging"

run_logged "${PACO_PACKAGING}/yay.sh"
run_logged "${PACO_PACKAGING}/zsh.sh"
run_logged "${PACO_PACKAGING}/tools-tier1.sh"
run_logged "${PACO_PACKAGING}/tools-tier2.sh"
run_logged "${PACO_PACKAGING}/fonts.sh"
run_logged "${PACO_PACKAGING}/starship.sh"
run_logged "${PACO_PACKAGING}/tools-tier4.sh"
run_logged "${PACO_PACKAGING}/dev-tools.sh"
run_logged "${PACO_PACKAGING}/ghostty.sh"
run_logged "${PACO_PACKAGING}/tools-tier3.sh"
run_logged "${PACO_PACKAGING}/nvim.sh"
run_logged "${PACO_PACKAGING}/podman.sh"
run_logged "${PACO_PACKAGING}/hyprland.sh"
