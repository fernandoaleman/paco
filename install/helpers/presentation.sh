#!/usr/bin/env bash
# shellcheck disable=SC2154
# Visual: banner, color palette, gum env defaults.
# PACO_PATH is set by install.sh before this is sourced.

export GUM_INPUT_PROMPT_FOREGROUND="#89b4fa"
export GUM_CHOOSE_CURSOR_FOREGROUND="#89b4fa"
export FOREGROUND_OK="#a6e3a1"
export FOREGROUND_WARN="#f9e2af"
export FOREGROUND_ERR="#f38ba8"

# RGB equivalents (used by paco_section's direct printf, which renders
# identically whether stdout is a TTY or piped through run_logged's tee).
export PACO_RGB_OK="166;227;161"   # #a6e3a1
export PACO_RGB_WARN="249;226;175" # #f9e2af
export PACO_RGB_ERR="243;139;168"  # #f38ba8

# Force gum to emit ANSI colors even when its stdout is piped (e.g., through
# run_logged's `tee`). Without these, gum auto-detects non-TTY and outputs
# plain text. Side effect: install.log will contain ANSI escape codes — view
# with `cat` (renders) or `less -R`. Set NO_COLOR=1 to override.
export FORCE_COLOR=1
export CLICOLOR_FORCE=1

# Tell lipgloss (gum's styling engine) the terminal supports 24-bit color.
# Without this, gum falls back to 256-color in non-TTY contexts (even with
# FORCE_COLOR), producing slightly different shades than direct-TTY output.
export COLORTERM=truecolor

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
  # Direct printf with raw 24-bit ANSI escape codes. Same bytes whether
  # called from a TTY (install.sh direct) or piped via run_logged's tee
  # — eliminates the gum profile-detection inconsistency.
  printf '\033[1;38;2;%sm==> %s\033[0m\n' "${PACO_RGB_OK}" "$1"
}
