#!/usr/bin/env bash
# shellcheck disable=SC2154
# Visual: banner, color palette, gum env defaults.
# PACO_PATH is set by install.sh before this is sourced.

export GUM_INPUT_PROMPT_FOREGROUND="#89b4fa"
export GUM_CHOOSE_CURSOR_FOREGROUND="#89b4fa"
export FOREGROUND_OK="#a6e3a1"
export FOREGROUND_WARN="#f9e2af"
export FOREGROUND_ERR="#f38ba8"

paco_banner() {
  local logo_file="${PACO_PATH}/logo.txt"
  if [[ -r "${logo_file}" ]]; then
    gum style --foreground "#89b4fa" --bold "$(cat "${logo_file}")"
  fi
  gum style --foreground "#cdd6f4" \
    "opinionated Arch + Hyprland distribution"
  echo
}

paco_section() {
  echo
  gum style --foreground "${FOREGROUND_OK}" --bold "==> $1"
}
