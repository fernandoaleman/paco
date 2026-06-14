#!/usr/bin/env bash
# shellcheck disable=SC2154
# Visual: banner, color palette, gum env defaults.
# PACO_PATH is set by install.sh before this is sourced.

# Install-output colors are sourced from the active theme's colors.toml
# (color1=red→ERR, color2=green→OK, color3=yellow→WARN, accent→prompts).
# Falls back to catppuccin-macchiato defaults if no theme is set yet
# (fresh install before any `paco theme-set` has run).

__paco_hex_to_rgb() {
  local hex="${1#\#}"
  printf '%d;%d;%d' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

# Defaults (catppuccin-macchiato).
__paco_accent="#8aadf4"
__paco_ok="#a6da95"
__paco_warn="#eed49f"
__paco_err="#ed8796"

__paco_theme_colors="${HOME}/.config/paco/current/theme/colors.toml"
if [[ -f "${__paco_theme_colors}" ]]; then
  while IFS='=' read -r __key __value; do
    __key="${__key//[\"\' ]/}"
    [[ -n ${__key} && ${__key} != \#* ]] || continue
    __value="${__value#*[\"\']}"
    __value="${__value%%[\"\']*}"
    case "${__key}" in
      accent) __paco_accent="${__value}" ;;
      color1) __paco_err="${__value}" ;;
      color2) __paco_ok="${__value}" ;;
      color3) __paco_warn="${__value}" ;;
      *) ;; # ignore all other keys
    esac
  done < "${__paco_theme_colors}"
  unset __key __value
fi
unset __paco_theme_colors

export GUM_INPUT_PROMPT_FOREGROUND="${__paco_accent}"
export GUM_CHOOSE_CURSOR_FOREGROUND="${__paco_accent}"
export FOREGROUND_OK="${__paco_ok}"
export FOREGROUND_WARN="${__paco_warn}"
export FOREGROUND_ERR="${__paco_err}"

# RGB equivalents for paco_section's direct printf (renders identically
# whether stdout is a TTY or piped through run_logged's tee).
PACO_RGB_OK="$(__paco_hex_to_rgb "${__paco_ok}")"
PACO_RGB_WARN="$(__paco_hex_to_rgb "${__paco_warn}")"
PACO_RGB_ERR="$(__paco_hex_to_rgb "${__paco_err}")"
export PACO_RGB_OK PACO_RGB_WARN PACO_RGB_ERR

unset __paco_accent __paco_ok __paco_warn __paco_err

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
    gum style --foreground "${GUM_INPUT_PROMPT_FOREGROUND}" --bold \
      "$(cat "${logo_file}")"
  fi
  gum style --foreground "${FOREGROUND_OK}" \
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
