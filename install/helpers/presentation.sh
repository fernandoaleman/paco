#!/usr/bin/env bash
# shellcheck disable=SC2154
# Visual: banner, color palette, gum env defaults.
# PACO_PATH is set by install.sh before this is sourced.

export GUM_INPUT_PROMPT_FOREGROUND="#89b4fa"
export GUM_CHOOSE_CURSOR_FOREGROUND="#89b4fa"
export FOREGROUND_OK="#a6e3a1"
export FOREGROUND_WARN="#f9e2af"
export FOREGROUND_ERR="#f38ba8"

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
  gum style --foreground "${FOREGROUND_OK}" --bold "==> $1"
}
