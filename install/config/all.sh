#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
# Config phase: wire up user-facing app configs.

PACO_CONFIG="${PACO_INSTALL}/config"

run_logged "${PACO_CONFIG}/zsh-layout.sh"
run_logged "${PACO_CONFIG}/default-shell.sh"
run_logged "${PACO_CONFIG}/fontconfig.sh"
run_logged "${PACO_CONFIG}/starship.sh"
run_logged "${PACO_CONFIG}/git-paco-defaults.sh"
run_logged "${PACO_CONFIG}/ghostty.sh"
run_logged "${PACO_CONFIG}/tmux.sh"
run_logged "${PACO_CONFIG}/nvim.sh"
run_logged "${PACO_CONFIG}/mise.sh"
run_logged "${PACO_CONFIG}/yay-defaults.sh"
run_logged "${PACO_CONFIG}/pacman-makepkg.sh"
