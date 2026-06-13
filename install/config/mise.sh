#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2154
set -euo pipefail

paco_section "Configuring mise + installing declared tools"

# 1. Symlink the paco mise config.
target_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/mise"
target="${target_dir}/config.toml"
source_file="${PACO_PATH}/default/mise/config.toml"

mkdir -p "${target_dir}"

if [[ -L "${target}" ]] && [[ "$(readlink "${target}")" == "${source_file}" ]]; then
  echo "mise config already symlinked."
else
  if [[ -e "${target}" ]] && [[ ! -L "${target}" ]]; then
    backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    echo "Backing up existing ${target} → ${backup}"
    mv "${target}" "${backup}"
  fi
  ln -sfn "${source_file}" "${target}"
  echo "Symlinked ${target} → ${source_file}"
fi

# 2. Install declared tools. Idempotent (no-op when already at target version).
# First run compiles Python + Ruby from source — takes 5–15 minutes.
echo "Running mise install (first run compiles Python + Ruby — may take 5–15 min)..."
mise install

# 3. Install nvim provider bridges into the mise-managed runtimes.
# pip --upgrade and gem --conservative are no-ops when already current.
echo "Installing pynvim into mise's python..."
mise exec python -- python -m pip install --upgrade pynvim

echo "Installing neovim gem into mise's ruby..."
mise exec ruby -- gem install --conservative neovim

echo "mise + nvim providers ready."
