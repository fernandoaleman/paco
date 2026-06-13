#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring zsh (XDG layout)"

# 1. Render the expected ~/.zshenv content for byte-exact comparison.
zshenv_expected="$(mktemp)"
trap 'rm -f "${zshenv_expected}"' EXIT

cat > "${zshenv_expected}" << 'EOF'
# Shipped by paco — XDG Base Directory shim.
# All other zsh config lives at ${ZDOTDIR}.

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
EOF

if [[ -f "${HOME}/.zshenv" ]] && cmp -s "${zshenv_expected}" "${HOME}/.zshenv"; then
  echo "${HOME}/.zshenv already in place."
else
  install -Dm644 "${zshenv_expected}" "${HOME}/.zshenv"
  echo "${HOME}/.zshenv written."
fi

# 2. Ensure XDG dirs exist for zsh cache + state.
mkdir -p "${XDG_CACHE_HOME:-${HOME}/.cache}/zsh"
mkdir -p "${XDG_STATE_HOME:-${HOME}/.local/state}/zsh"

# 3. Symlink ~/.config/zsh → PACO_PATH/default/zsh.
#    If a non-symlink already exists, back it up (preserves user customization).
config_zsh="${XDG_CONFIG_HOME:-${HOME}/.config}/zsh"
target="${PACO_PATH}/default/zsh"

if [[ -e "${config_zsh}" ]] && [[ ! -L "${config_zsh}" ]]; then
  backup="${config_zsh}.backup.$(date +%Y%m%d-%H%M%S)"
  echo "Backing up existing ${config_zsh} → ${backup}"
  mv "${config_zsh}" "${backup}"
fi

mkdir -p "$(dirname "${config_zsh}")"
ln -sfn "${target}" "${config_zsh}"
echo "Symlinked ${config_zsh} → ${target}"
