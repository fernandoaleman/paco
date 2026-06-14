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
run_logged "${PACO_CONFIG}/lazydocker.sh"
run_logged "${PACO_CONFIG}/podman-socket.sh"
run_logged "${PACO_CONFIG}/podman-environment.sh"
run_logged "${PACO_CONFIG}/hyprland.sh"
run_logged "${PACO_CONFIG}/waybar.sh"
run_logged "${PACO_CONFIG}/mako.sh"
run_logged "${PACO_CONFIG}/vicinae.sh"
run_logged "${PACO_CONFIG}/networking.sh"
run_logged "${PACO_CONFIG}/bluetooth.sh"
run_logged "${PACO_CONFIG}/power.sh"
run_logged "${PACO_CONFIG}/firewall.sh"
run_logged "${PACO_CONFIG}/theme-default.sh"
